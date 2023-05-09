//
//  Model.swift
//  ExchangeData
//
//  Created by Michele Manniello on 07/05/23.
//

import Foundation

struct Contatore: Encodable, Decodable, Equatable {
    init() {
        number = ""
        addendo = ""
    }
    var number: String
    var addendo: String
}
