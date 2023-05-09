//
//  Counter.swift
//  ExchangeData
//
//  Created by Michele Manniello on 01/05/23.
//

import SwiftUI

struct Counter: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var index: Int = 0
    @State var numberOfAument: Int = 1
    var body: some View {
        VStack (alignment: .center,spacing: 40){
            HStack {
                Text("Contatore")
                    .font(.largeTitle)
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
            
            HStack(spacing: 40) {
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .fontWeight(.bold)
                    .onTapGesture {
                        index += numberOfAument
                        viewModel.contatore.number = index.description
                        viewModel.contatore.addendo = numberOfAument.description
                        viewModel.sendCounter(session: viewModel.session,
                                              counter: viewModel.contatore)
                    }

                Menu {
                    ForEach(0..<10) { index in
                        Button {
                            self.numberOfAument = index
                            viewModel.contatore.addendo = index.description
                            viewModel.sendCounter(session: viewModel.session,
                                                  counter: viewModel.contatore)
                        } label: {
                            Text(index.description)
                            if numberOfAument == index {
                                Image(systemName: "checkmark")
                            }
                        }

                    }
                } label: {
                    Text(numberOfAument.description)
                        .padding(.horizontal,40)
                        .padding(.vertical,10)
                        .foregroundColor(.white)
                        .background(
                            Rectangle()
                                .cornerRadius(30)
                        )
                }
                
                Image(systemName: "minus")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .onTapGesture {
                        guard index > 0, index - numberOfAument >= 0 else { return }
                        index -= numberOfAument
                        viewModel.contatore.number = index.description
                        viewModel.contatore.addendo = numberOfAument.description
                        viewModel.sendCounter(session: viewModel.session,
                                              counter: viewModel.contatore)
                    }
                
            }
            
            Button {
                index = 0
                numberOfAument = 1
                viewModel.contatore.addendo = index.description
                viewModel.contatore.number = numberOfAument.description
                viewModel.sendCounter(session: viewModel.session,
                                      counter: viewModel.contatore)
            } label: {
                Text("Reset")
            }
            .padding(.horizontal,40)
            .padding(.vertical,10)
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .foregroundColor(.red)
                    .cornerRadius(30)
            )
            Spacer()

        }
        .onChange(of: viewModel.contatore) { newValue in
            print(newValue)
            self.index = Int(newValue.number) ?? 0
            self.numberOfAument = Int(newValue.addendo) ?? 0
        }
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
            .environmentObject(ViewModel())
    }
}
