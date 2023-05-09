//
//  DocumentPicker.swift
//  ExchangeData
//
//  Created by Michele Manniello on 01/05/23.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker : UIViewControllerRepresentable {
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    @Binding var alert : Bool
    @Binding var urlPath: URL?
   
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [UTType.pdf]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    class Coordinator: NSObject,UIDocumentPickerDelegate {
        var parent : DocumentPicker
        init(parent1: DocumentPicker) {
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.parent.urlPath = urls.first
            self.parent.alert = false
        }
    }
}
