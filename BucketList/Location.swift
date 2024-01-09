//
//  Location.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/8/24.
//

import Foundation
import MapKit


struct Location: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double // storing these as a double to be able to use them with codable
    var longitute: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
    }
    
    // wtih this if else, it won't be shipped to the users app/phone
    #if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by a lot of lightbulbs", latitude: 51.501, longitute: -0.141)
    #endif
    
    
    // making own func for Equatable so that it does not compare all the properties bc we know if the ids are not the same, they have to be different
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}
