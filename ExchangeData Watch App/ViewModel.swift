//
//  ViewModel.swift
//  ExchangeData Watch App
//
//  Created by Michele Manniello on 29/04/23.
//

import Foundation

import WatchConnectivity

class ViewModel: NSObject, ObservableObject, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @Published var response = ""
    @Published var message = ""
    
    var online: Bool {
        guard let session = self.session else { return false }
        return session.isReachable
    }
    
    private var session: WCSession?
    
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
    
    func sendMessage() {
        guard let session = self.session else { return }
//    MARK: controllo che sono connesso
        guard session.isReachable else { return }
//    MARK: send message
        let messageToSend = ["Messaggio" : message]
        session.sendMessage(messageToSend, replyHandler: nil) { error in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        DispatchQueue.main.async {
            
            if message["Counter"] != nil {
                let counter = message["Counter"] as? [String: Int]
                let index = counter?["Index"] as? Int ?? 0
                let numberOfAument = counter?["NumberOfAument"] as? Int ?? 0
                self.response = "\(index.description),\(numberOfAument.description)"
                print(self.response)
                
            } else {
                self.response = message["Messaggio"] as? String ?? ""
            }
          
        }
    }
    
//    MARK: messaggi accantonati
    /// molteplici invi da parte di questo metdo saranno inviati sequenzialmente -> Ottimo sistema in caso di app di news
    func sendMessageType1() {
        guard let session = self.session else { return }
        guard session.isReachable else { return }
        
        let messageToSend = ["Messaggio" : message]
        do {
            try session.updateApplicationContext(messageToSend)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.response = applicationContext["Messaggio"] as? String ?? ""
        }
    }
    
//    MARK: messaggi in background
    func sendMessageType2() {
        guard let session = self.session else { return }
        guard session.isReachable else { return }
        let messageToSend = ["Messaggio" : message]
        session.transferUserInfo(messageToSend)
        print("Send")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.response = userInfo["Messaggio"] as? String ?? ""
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = file.fileURL
        print(url)
        DispatchQueue.main.async {
            self.response = url.absoluteString
        }
    }
    
    func sendCounter(value: Int, numberOfAument: Int) {
        guard let session = self.session else { return }
//    MARK: controllo che sono connesso
        guard session.isReachable else { return }
        let dictionary: [String: [String: Int]] = [
            "Counter": [
                "Index": value,
                "NumberOfAument":numberOfAument
            ]
        ]
        session.sendMessage(dictionary,replyHandler: nil){ error in
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
