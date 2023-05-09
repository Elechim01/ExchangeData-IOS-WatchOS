//
//  PDFView.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 07/05/23.
//

import SwiftUI

struct PDFView: View {
    @EnvironmentObject var viewModel: WatchViewModel
    @State var showAlert: Bool = false
    @State var selectURL: URL?
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(viewModel.online ? .green : .red)
                    Text(viewModel.online ? "Online" : "Offline")
                        .font(.subheadline)
                }
                Text("Seleziona il file da inviare")
                    .lineLimit(2)
                    .padding(.bottom)
                ForEach(0..<viewModel.files.count,id:\.self) { index in
                    let file = viewModel.files[index]
                    Button {
    //                    UPload file
                        self.selectURL = file
                        self.showAlert.toggle()
                    } label: {
                        Text(file.lastPathComponent)
                    }
                    .padding()
                }
            }
        }
        .alert("Vuoi inviare il seguente documento: \(selectURL?.lastPathComponent ?? "")", isPresented: $showAlert) {
            Button("Invia") {
                guard let url = self.selectURL else { return }
                viewModel.sendFile(session: viewModel.session, file: url)
            }
            .padding(.bottom)
            
            Button("Annulla") {
                self.showAlert.toggle()
            }
        }
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView()
            .environmentObject(WatchViewModel())
    }
}
