//
//  ContentViewModel.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import Foundation
import SwiftUI
import CoreML
import Vision

class ContentViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var plantName: String = "Identified As: "
    @Published var confidence: String = "Confidence: "
    @Published var showingImagePicker: Bool = false
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToSavedObservations: Bool = false

    private let dataStore = DataStore() // DataStore instance

    // MARK: - Image Selection & Core ML Logic

    func processImage() {
        guard let inputImage = selectedImage else {
            plantName = "Identified As: No image selected"
            confidence = "Confidence: N/A"
            return
        }

        guard let ciImage = CIImage(image: inputImage) else {
            alertMessage = "Could not convert UIImage to CIImage."
            showingAlert = true
            return
        }

        // Replace MobileNetV2() with your actual Core ML model name
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            alertMessage = "Failed to load Core ML model. Make sure the .mlmodel file is added correctly and target membership is set."
            showingAlert = true
            return
        }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Image classification failed: \(error.localizedDescription)"
                    self.showingAlert = true
                }
                return
            }

            guard let observations = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    self.alertMessage = "Model returned no observations."
                    self.showingAlert = true
                }
                return
            }

            if let bestResult = observations.first {
                let identifier = bestResult.identifier.capitalized.replacingOccurrences(of: "_", with: " ")
                let confidenceScore = String(format: "%.2f%%", bestResult.confidence * 100)
                
                DispatchQueue.main.async {
                    self.plantName = "Identified As: \(identifier)"
                    self.confidence = "Confidence: \(confidenceScore)"
                }
            } else {
                DispatchQueue.main.async {
                    self.plantName = "Identified As: Unknown"
                    self.confidence = "Confidence: Low"
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to perform classification: \(error.localizedDescription)"
                    self.showingAlert = true
                }
            }
        }
    }

    // MARK: - Save Logic

    func saveCurrentObservation() {
        guard let imageToSave = selectedImage,
              plantName != "Identified As: ",
              plantName != "Identified As: No image selected",
              plantName != "Identified As: Unknown" else {
            alertMessage = "No valid plant identified to save."
            showingAlert = true
            return
        }

        // Image ko file system mein save karein
        let imageName = UUID().uuidString + ".png" // Har baar ek naya unique filename
        if dataStore.saveImageToDocumentsDirectory(image: imageToSave, withName: imageName) {
            var allObservations = dataStore.loadObservations() // Load existing
            let newObservation = Observation(
                imageName: imageName,
                plantName: plantName,
                confidence: confidence,
                date: Date()
            )
            allObservations.append(newObservation)
            dataStore.saveObservations(allObservations) // Save updated list
            alertMessage = "Result saved successfully!"
            showingAlert = true
            
            // ---  UI State Reset ---
        
            self.selectedImage = nil
            self.plantName = "Identified As: "
            self.confidence = "Confidence: "
            
        } else {
            alertMessage = "Failed to save image."
            showingAlert = true
        }
    }

    // MARK: - UI Actions (called by View)
    
    func openImagePicker() {
        showingImagePicker = true
    }
    
    func imagePickedAndProcessed() {
        processImage()
    }
    
    func viewSavedResults() {
        navigateToSavedObservations = true
    }
}
