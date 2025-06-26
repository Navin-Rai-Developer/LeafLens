//
//  ContentView.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Image View / Placeholder
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            viewModel.openImagePicker()
                        }
                    Text("Tap to Add Image")
                        .foregroundColor(.gray)
                }

                Button("Identify Plant") {
                    viewModel.openImagePicker()
                }
                .font(.headline)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)

                Spacer()

                Text(viewModel.plantName)
                    .font(.title2)
                    .padding(.bottom, 5)

                Text(viewModel.confidence)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)

                ScrollView {
                    Text("About Plant: Information about the identified plant will appear here. This could include common characteristics, care tips, or interesting facts fetched from an external source like Wikipedia.")
                        .font(.body)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                
                // --- Save Result Button ---
                if viewModel.selectedImage != nil && viewModel.plantName != "Identified As: " && viewModel.plantName != "Identified As: No image selected" && viewModel.plantName != "Identified As: Unknown" {
                    Button("Save This Result") {
                        viewModel.saveCurrentObservation() // Action to ViewModel
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                // --- End Save Result Button ---

                Spacer()

                // --- View Saved Results Button ---
                NavigationLink(destination: SavedObservationsView(), isActive: $viewModel.navigateToSavedObservations) {
                    EmptyView()
                }
                Button("View Saved Results") {
                    viewModel.viewSavedResults()
                }
                .font(.headline)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
                // --- View Saved Results Button ---
            }
            .navigationTitle("Leaf Lens")
            .sheet(isPresented: $viewModel.showingImagePicker, onDismiss: { viewModel.imagePickedAndProcessed() }) {
                ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ContentView()
}
