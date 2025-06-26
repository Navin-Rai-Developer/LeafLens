//
//  SavedObservationView.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import SwiftUI

struct SavedObservationsView: View {
    @StateObject private var viewModel = SavedObservationsViewModel()

    var body: some View {
        List {
            if viewModel.observations.isEmpty {
                Text("No saved observations yet. Identify some plants first!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(viewModel.observations.reversed()) { observation in
                    ObservationRow(observation: observation, viewModel: viewModel)
                }
                .onDelete(perform: viewModel.deleteObservation) 
            }
        }
        .navigationTitle("Saved Results")
        .onAppear(perform: viewModel.loadObservations)
    }
}

#Preview {
    SavedObservationsView()
}
