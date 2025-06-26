//
//  ObservationRow.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import SwiftUI

struct ObservationRow: View {
    let observation: Observation
    @ObservedObject var viewModel: SavedObservationsViewModel
    @State private var loadedImage: UIImage?

    var body: some View {
        HStack {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(ProgressView())
            }

            VStack(alignment: .leading) {
                Text(observation.plantName)
                    .font(.headline)
                Text(observation.confidence)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(observation.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .onAppear(perform: loadImageForObservation)
    }

    func loadImageForObservation() {
        loadedImage = viewModel.loadImageForObservation(observation)
    }
}

#Preview {
    let dummyObservation = Observation(
        imageName: "dummy_plant",
        plantName: "Sample Rose",
        confidence: "95.5%",
        date: Date()
    )
    let dummyViewModel = SavedObservationsViewModel()
    
    ObservationRow(observation: dummyObservation, viewModel: dummyViewModel)
        .previewLayout(.sizeThatFits)
        .padding()
}
