//
//  Counter.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Counter: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var index: Int = 0
    @State var numberOfAument: Int = 1
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
                            viewModel.sendCounter(value: index, numberOfAument: numberOfAument)
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
                            viewModel.sendCounter(value: index, numberOfAument: numberOfAument)
                        }
                }
                
                Button {
                    index = 0
                    numberOfAument = 1
                    viewModel.sendCounter(value: index, numberOfAument: numberOfAument)
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
        .onChange(of: viewModel.response) { newValue in
            let new = newValue.split(separator: ",")
            guard !new.isEmpty, new.count == 2 else { return }
            self.index = Int(new[0]) ?? 0
            self.numberOfAument = Int(new[1]) ?? 0
        }
    }
}


struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
            .environmentObject(ViewModel())
    }
}
