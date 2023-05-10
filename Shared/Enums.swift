//
//  Enums.swift
//  ExchangeData
//
//  Created by Michele Manniello on 01/05/23.
//

import Foundation

enum Options: String, CaseIterable {
    case message = "Mesaggio"
    case counter = "Contatore"
    case pdf = "PDF"
    
    public static func getElement(number: Int) -> Options?{
        switch number {
        case 0:
            return .message
        case 1:
            return .counter
        case 2:
            return .pdf
        default:
           return nil
        }
    }
}

enum TypeOfMessage: String, CaseIterable {
    case normal = "Normale"
    case shelve = "Accantonati"
    case background = "Background"
    
    public static func getElement(number: Int) -> TypeOfMessage? {
        switch number {
        case 0:
            return .normal
        case 1:
            return .shelve
        case 2:
            return .background
        default:
            return nil
        }
    }
    
}

enum ExchangeDataError: Error {
    case generic(description: String)
    case noSession
    case notReachable
    
    var localizedDescription: String {
        switch self {
        case .generic(let description):
            return description
        case .noSession:
            return "Errore interno"
        case .notReachable:
            return "Dispositivo non connesso riprova"
        }
    }
}
