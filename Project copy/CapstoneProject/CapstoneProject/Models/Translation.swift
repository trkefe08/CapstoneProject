//
//  Translation.swift
//  CapstoneProject
//
//  Created by tarik.efe on 9.08.2022.
//

import Foundation

struct Translation: Codable {
    let iso3166_1, iso639_1, name, englishName: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case iso639_1 = "iso_639_1"
        case name
        case englishName = "english_name"
        case data
    }
}
