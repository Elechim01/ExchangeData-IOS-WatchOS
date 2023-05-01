//
//  Message.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Message: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                Text("Messaggio")
                    .font(.title3)
                
                TextField("Invia il tuo messaggio", text: $viewModel.message)
                    .textFieldStyle(ClipTextField())
                    .padding(.horizontal,5)
                
                Text("Risposta\n\(viewModel.response)")
                
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Invia")
                        .foregroundColor(.white)
                }
                
                .buttonStyle(BorderedButtonStyle(tint: .blue))
                .padding(.horizontal,10)
                .padding(.vertical,10)
                
                Spacer()
            }
        }
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
            .environmentObject(ViewModel())
    }
}
