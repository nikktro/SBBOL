//
//  ReturnedJson.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 17.06.2021.
//

import Foundation

struct ReturnedJson: Codable {
    var translations: [TranslatedStrings]
}

struct TranslatedStrings: Codable {
    var text: String
    var to: String
}
