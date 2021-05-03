//
//  Country.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import Foundation

struct Country: Decodable {
    let name: String
    let nativeName: String
    let alpha3Code: String
    let borders: [String]
    let area: Double?
}
