//
//  PDFKitReppresentedView.swift
//  ExchangeData
//
//  Created by Michele Manniello on 07/05/23.
//

import Foundation
import UIKit
import PDFKit
import SwiftUI

struct PDFKitReppresentedView: UIViewRepresentable {

    typealias UIViewType = PDFView

    let url: URL?
    init(url: URL?) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> UIViewType {
        guard let url = self.url else { return  UIViewType() }
        let pdfView = UIViewType()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = self.url else { return  }
        uiView.document = PDFDocument(url: url)
    }
    
}
