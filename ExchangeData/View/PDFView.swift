//
//  PDFView.swift
//  ExchangeData
//
//  Created by Michele Manniello on 07/05/23.
//

import SwiftUI

struct PDFSWIView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var showPDFPicker = false
    @State var url: URL?
    @State var messageError: String = ""
    @State var showError: Bool = false
    var body: some View {
        VStack{
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(viewModel.online ? .green : .red)
                Text(viewModel.online ? "Online" : "Offline")
                    .font(.subheadline)
                Button {
                    showPDFPicker.toggle()
                } label: {
                    Text("Carica il tuo PDF")
                }
                
                if let nUrl = url {
                    Button {
                        //                        UPload to Watch
                        viewModel.sendFile(session: viewModel.session, file: nUrl) { error in
                            messageError = error.localizedDescription
                            showError.toggle()
                        }
                        self.url = nil
                    } label: {
                        Image(systemName: "arrow.up.doc")
                            .font(.title2)
                    }
                }
            }
            .padding()
            
            if url != nil {
                    PDFKitReppresentedView(url: url)
            } else {
                Text("PDF Ricevuti")
                ForEach(0..<viewModel.files.count,id:\.self) { index in
                    let file = viewModel.files[index]
                    Text(file.lastPathComponent)
                        .padding()
                    
                }
            }
        }
        
        .sheet(isPresented: $showPDFPicker) {
            DocumentPicker(alert: $showPDFPicker, urlPath: $url)
        }
        .alert("Errore:\n\(messageError)", isPresented: $showError) {
            Button("Chiudi") {
                showError.toggle()
            }
        }
        
        
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFSWIView()
            .environmentObject(ViewModel())
    }
}
