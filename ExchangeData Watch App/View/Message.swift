//
//  Message.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Message: View {
    @EnvironmentObject var viewModel: WatchViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var messageError: String = ""
    @State var showError: Bool = false
    
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
                    viewModel.sendMessage(session: viewModel.session, message: viewModel.message) { error in
                        messageError = error.localizedDescription
                        showError.toggle()
                        
                    }
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
        .alert("Errore:\n\(messageError)", isPresented: $showError) {
            Button("Chiudi") {
                showError.toggle()
            }
        }
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
            .environmentObject(WatchViewModel())
    }
}
