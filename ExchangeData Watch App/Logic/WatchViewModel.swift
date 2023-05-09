//
//  ViewModel.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 29/04/23.
//

import Foundation
import UIKit
import WatchConnectivity


final class WatchViewModel: NSObject, ObservableObject, WCSessionDelegate, SendOperation {
    
    @Published var response = ""
    @Published var message = ""
    @Published var files: [URL] = []
    @Published var contatore: Contatore = Contatore()
    
    var online: Bool {
        guard let session = self.session else { return false }
        return session.isReachable
    }
    
    var session: WCSession?
    
    init(response: String = "", message: String = "") {
        super.init()
        self.response = response
        self.message = message
        if WCSession.isSupported() {
            self.session = .default
            self.session?.delegate = self
            self.session?.activate()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        DispatchQueue.main.async {
            self.response = message["Messaggio"] as? String ?? ""
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.response = applicationContext["Messaggio"] as? String ?? ""
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.response = userInfo["Messaggio"] as? String ?? ""
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = file.fileURL
        
        DispatchQueue.main.async {
            
            let filemanager = FileManager.default
            guard let docuentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Directory non trovata")
                return
            }
            
            let fileURL = docuentDirectory.appending(path: "text\(self.files.count).pdf")
            do {
                let messageData = try Data(contentsOf: url)
                try messageData.write(to: fileURL,options: .atomic)
                
                self.files.append(fileURL)
                print("Succes")
            } catch {
                print("Error")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            do {
                self.contatore = try JSONDecoder().decode(Contatore.self, from: messageData)
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
