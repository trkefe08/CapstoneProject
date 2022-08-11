//
//  Result.swift
//  CapstoneProject
//
//  Created by tarik.efe on 25.07.2022.
//

import Foundation

struct Movie: Codable {
    var page: Int
    let results: [ResultElement]?
    var totalPages: Int
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
