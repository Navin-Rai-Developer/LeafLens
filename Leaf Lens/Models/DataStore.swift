//
//  DataStore.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import Foundation
import UIKit

class DataStore {
    private let observationsKey = "savedPlantObservations"
    private let fileManager = FileManager.default

    // MARK: - Observation Handling

    func saveObservations(_ observations: [Observation]) {
        if let encoded = try? JSONEncoder().encode(observations) {
            UserDefaults.standard.set(encoded, forKey: observationsKey)
        }
    }

    func loadObservations() -> [Observation] {
        if let savedData = UserDefaults.standard.data(forKey: observationsKey) {
            if let decodedObservations = try? JSONDecoder().decode([Observation].self, from: savedData) {
                return decodedObservations
            }
        }
        return []
    }

    // MARK: - Image Handling

    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func saveImageToDocumentsDirectory(image: UIImage, withName name: String) -> Bool {
        guard let data = image.pngData() else { return false }
        let url = getDocumentsDirectory().appendingPathComponent(name)
        do {
            try data.write(to: url)
            return true
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return false
        }
    }

    func loadImageFromDocumentsDirectory(imageName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(imageName)
        guard fileManager.fileExists(atPath: url.path) else {
            print("Image file does not exist at path: \(url.path)")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteImageFromDocumentsDirectory(imageName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(imageName)
        do {
            try fileManager.removeItem(at: fileURL)
            print("Deleted image: \(fileURL.lastPathComponent)")
        } catch {
            print("Could not delete image: \(error.localizedDescription)")
        }
    }
}
