//
//  ContentView.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 29/04/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
        ScrollView {
                VStack(spacing: 15) {
                    Text("Seleziona cosa mandare")
                        .font(.title3)
                    
                    ForEach(0..<Options.allCases.count) { value in
                        CustomNavigator(destination: Options.getElement(number: value))
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func CustomNavigator(destination: Options?) -> some  View {
        guard let typeOfDestination = destination else { return AnyView(EmptyView()) }
        return AnyView(  NavigationLink {
            switch typeOfDestination {
            case .message:
                Message()
                    .environmentObject(viewModel)
            case .counter:
                Counter()
                    .environmentObject(viewModel)
            }
        } label: {
            HStack(alignment: .center){
                Spacer(minLength: 0)
                
                Text(typeOfDestination.rawValue)
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.right")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 20)
                    .padding(.trailing,20)
            }
            .padding(5)
        }
            .padding(.horizontal,5)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
