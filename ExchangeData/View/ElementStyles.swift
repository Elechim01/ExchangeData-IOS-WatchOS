//
//  ElementStyles.swift
//  ExchangeData
//
//  Created by Michele Manniello on 01/05/23.
//

import Foundation
import SwiftUI

struct ClipTextField: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.1))
                    .cornerRadius(30)
                   
            }
            .shadow(radius: 3)
    }
}
