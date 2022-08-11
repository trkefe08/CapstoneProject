//
//  Cast.swift
//  CapstoneProject
//
//  Created by tarik.efe on 9.08.2022.
//

import Foundation

struct Cast: Codable {
    let id: Int?
    let cast, crew: [CastElement]?
}
