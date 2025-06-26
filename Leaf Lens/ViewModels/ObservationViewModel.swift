//
//  ObservationViewModel.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import Foundation
import UIKit

class SavedObservationsViewModel: ObservableObject {
    @Published var observations: [Observation] = []
    private let dataStore = DataStore()

    func loadObservations() {
        observations = dataStore.loadObservations()
    }

    func deleteObservation(at offsets: IndexSet) {
        // Since we display observations.reversed(), need to adjust indices for deletion on original array
        let originalIndicesToDelete = offsets.map { observations.count - 1 - $0 }
        
        // Delete images first
        for index in originalIndicesToDelete {
            let observationToDelete = observations[index]
            dataStore.deleteImageFromDocumentsDirectory(imageName: observationToDelete.imageName)
        }
        
        // Remove from the array and save
        var currentObservations = dataStore.loadObservations()
        // Filter out observations based on the IDs of those to be deleted
        let idsToDelete = originalIndicesToDelete.map { observations[$0].id }
        currentObservations.removeAll { idsToDelete.contains($0.id) }
        
        dataStore.saveObservations(currentObservations)
        loadObservations() // Reload to reflect changes
    }
    
    // This is for the ObservationRow to load its image
    func loadImageForObservation(_ observation: Observation) -> UIImage? {
        dataStore.loadImageFromDocumentsDirectory(imageName: observation.imageName)
    }
}
