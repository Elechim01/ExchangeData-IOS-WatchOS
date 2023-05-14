//
//  ViewModel.swift
//  ExchangeData
//
//  Created by Michele Manniello on 29/04/23.
//

import Foundation

import WatchConnectivity

final class ViewModel: NSObject, ObservableObject, WCSessionDelegate, SendOperation {
    
    @Published var messaggio: String = ""
    @Published var response: String = ""
    @Published var files: [URL] = []
    @Published var contatore: Contatore = Contatore()
    
    var session: WCSession?
    
    var online: Bool {
        guard let session = self.session else { return false }
        return session.isReachable
    }
    
    init(request: String = "", response: String = "") {
        super.init()
        self.messaggio = request
        self.response = response
        if WCSession.isSupported() {
            self.session = .default
            self.session?.delegate = self
            self.session?.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        self.session = session
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.session = session
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
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
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            do {
                self.contatore = try JSONDecoder().decode(Contatore.self, from: messageData)
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = file.fileURL
        print(url.lastPathComponent)
        print(url)
        DispatchQueue.main.async {
            self.response = url.absoluteString
            self.files.append(url)
        }
    }
}
