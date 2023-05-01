//
//  Message.swift
//  ExchangeData
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Message: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var typeSelected: TypeOfMessage = .normal
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 0)
                Text("Messaggio")
                    .font(.largeTitle)
                Spacer(minLength: 0)
          
                Menu {
                    ForEach(0..<TypeOfMessage.allCases.count) { index in
                       Options(type: TypeOfMessage.getElement(number: index))
                    }
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .background {
                            Circle()
                                .frame(width: 30, height: 30)
                                .border(.background, width: 0)
                                .foregroundColor( colorScheme == .dark ? .black : .white)
                                .shadow(radius: 1)
                        }
                }
                .padding(.trailing,30)
            }
            .padding(.top,20)
            
            TextField("Invia il tuo messaggio", text: $viewModel.messaggio)
                .textFieldStyle(ClipTextField())
                .padding(10)
            
            Text("Risposta\n\(viewModel.response)")
                .padding(.vertical)
            
            Button {
                switch typeSelected {
                case .normal:
                    viewModel.sendMessage()
                case .shelve:
                    viewModel.sendMessageType1()
                case .background:
                    viewModel.sendMessageType2()
                }
            } label: {
                Text("Invia")
                    .foregroundColor(.white)
            }
            .padding(.horizontal,30)
            .padding(.vertical,10)
            .background {
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(30)
                    .shadow(radius: 3)
            }
            .padding(.top,30)

            Spacer()
        }
    }
    
      func Options(type: TypeOfMessage?) -> some View {
       guard let messageType = type else { return AnyView(EmptyView())}
       return AnyView(
        
        Button(action: {
            typeSelected = messageType
        }, label: {
            Text(messageType.rawValue)
            if typeSelected == messageType {
                Image(systemName: "checkmark")
            }
            
        })
        .foregroundColor(.black)
       
       )
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message()
            .environmentObject(ViewModel())
    }
}

