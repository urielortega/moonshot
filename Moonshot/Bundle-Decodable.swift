//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Uriel Ortega on 09/05/23.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else { // Locating the file in the Bundle.
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else { // Loading the data from the file URL.
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else { // Decoding the JSON file with Astronaut type.
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded // Return the decoded data.
    }
}
