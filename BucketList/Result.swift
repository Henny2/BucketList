//
//  Result.swift
//  BucketList
//
//  Created by Henrieke Baunack on 1/9/24.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
    
    var description: String {
        terms?["description"]?.first ?? "No further information available"
    }
}
