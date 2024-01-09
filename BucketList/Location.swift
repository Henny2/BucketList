//
//  Location.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/8/24.
//

import Foundation


struct Location: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double // storing these as a double to be able to use them with codable
    var longitute: Double
}
