//
//  Counter.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Counter: View {
    
    @EnvironmentObject var viewModel: WatchViewModel
    @State var index: Int = 0
    @State var numberOfAument: Int = 1
    @State var messageError: String = ""
    @State var showError: Bool = false
    var body: some View {
        ScrollView {
            VStack (alignment: .center,spacing: 20){
                HStack(alignment: .center) {
                    Text("Contatore")
                        .font(.title3)
                        .padding()
                    
                    VStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(viewModel.online ? .green : .red)
                        Text(viewModel.online ? "Online" : "Offline")
                            .font(.subheadline)
                    }
                }
                
                Text(index.description)
                    .font(.title3)
                
                HStack(spacing: 25) {
                    
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .fontWeight(.bold)
                        .onTapGesture {
                            index += numberOfAument
                            viewModel.contatore.number = index.description
                            viewModel.sendCounter(session: viewModel.session,
                                                  counter: viewModel.contatore) { error in
                                messageError = error.localizedDescription
                                showError.toggle()
                            }
                        }
                    
                    
                    Text(numberOfAument.description)
                        .padding(.horizontal,20)
                        .padding(.vertical,5)
                        .foregroundColor(.black)
                        .background(
                            Rectangle()
                                .cornerRadius(20)
                        )
                    
                    
                    Image(systemName: "minus")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .onTapGesture {
                            guard index > 0, index - numberOfAument >= 0 else { return }
                            index -= numberOfAument
                            viewModel.contatore.number = index.description
                            viewModel.sendCounter(session: viewModel.session,
                                                  counter: viewModel.contatore)  { error in
                                messageError = error.localizedDescription
                                showError.toggle()
                            }
                        }
                }
                
                Button {
                    index = 0
                    numberOfAument = 1
                    viewModel.contatore.addendo = index.description
                    viewModel.contatore.number = numberOfAument.description
                    viewModel.sendCounter(session: viewModel.session,
                                          counter: viewModel.contatore) { error in
                        messageError = error.localizedDescription
                        showError.toggle()
                    }
                } label: {
                    Text("Reset")
                }
                .buttonStyle(BorderedButtonStyle(tint: .red))
                .padding(.horizontal)
                .padding(.vertical,10)
                .foregroundColor(.white)
                .cornerRadius(30)
                
                Spacer()
                
            }
        }
        .onChange(of: viewModel.contatore) { newValue in
            print(newValue)
            self.index = Int(newValue.number) ?? 0
            self.numberOfAument = Int(newValue.addendo) ?? 0
        }
        .alert("Errore:\n\(messageError)", isPresented: $showError) {
            Button("Chiudi") {
                showError.toggle()
            }
        }
    }
}


struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
            .environmentObject(WatchViewModel())
    }
}
