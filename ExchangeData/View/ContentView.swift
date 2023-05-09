//
//  ContentView.swift
//  ExchangeData
//
//  Created by Michele Manniello on 29/04/23.
//

import SwiftUI


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 40) {
                Text("Seleziona cosa mandare")
                    .font(.title)
                    
                ForEach(0..<Options.allCases.count) { value in
                    CustomNavigator(destination: Options.getElement(number: value))
                }
                Spacer()
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
            case .pdf:
               PDFSWIView()
                    .environmentObject(viewModel)
            }
        } label: {
            HStack(alignment: .center){
                Spacer(minLength: 0)
                
                Text(typeOfDestination.rawValue)
                    .font(.title3)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing,20)
            }
            .padding(10)
        }
            .background {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.1))
            }
            .padding(.horizontal,10)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


