//
//  Model.swift
//  Leaf Lens
//
//  Created by Navin Rai on 26/06/25.
//

import Foundation
import UIKit // UIImage ke liye

struct Observation: Identifiable, Codable {
    var id = UUID() // Unique ID har observation ke liye
    let imageName: String // Image ko file system mein save karne ke liye naam
    let plantName: String
    let confidence: String
    let date: Date // Date of Scan

    // Codable protocols ke liye custom initializers
    enum CodingKeys: String, CodingKey {
        case id, imageName, plantName, confidence, date
    }

    init(imageName: String, plantName: String, confidence: String, date: Date) {
        self.imageName = imageName
        self.plantName = plantName
        self.confidence = confidence
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        plantName = try container.decode(String.self, forKey: .plantName)
        confidence = try container.decode(String.self, forKey: .confidence)
        date = try container.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(plantName, forKey: .plantName)
        try container.encode(confidence, forKey: .confidence)
        try container.encode(date, forKey: .date)
    }
}
