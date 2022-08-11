//
//  ProductionCompany.swift
//  CapstoneProject
//
//  Created by tarik.efe on 2.08.2022.
//

import Foundation

struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
