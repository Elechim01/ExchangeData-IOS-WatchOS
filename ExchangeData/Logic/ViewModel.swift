//
//  ViewModel.swift
//  ExchangeData
//
//  Created by Michele Manniello on 29/04/23.
//

import Foundation

import WatchConnectivity

class ViewModel: NSObject,ObservableObject, WCSessionDelegate {
    

    var online: Bool {
        guard let session = self.session else { return false }
        return session.isReachable
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        self.session = session
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.session = session
    }
    
   
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    @Published var messaggio: String = ""
    @Published var response: String = ""
    
    var session: WCSession?
    
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
    
    func initSession() {
        
    }
    
    func sendMessage() {
        guard let session = self.session else { return }
//    MARK: controllo che sono connesso
        guard session.isReachable else { return }
//    MARK: send message
        let messageToSend = ["Messaggio" : messaggio]
        session.sendMessage(messageToSend,replyHandler: nil){ error in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        DispatchQueue.main.async {
            
            if message["Counter"] != nil {
                let counter = message["Counter"] as? [String: Int]
                let index = counter?["Index"] as? Int ?? 0
                let numberOfAument = counter?["NumberOfAument"] as? Int ?? 0
                self.response = "\(index.description),\(numberOfAument.description)"
                
            } else {
                self.response = message["Messaggio"] as? String ?? ""
            }
        }
    }

    
    //    MARK: messaggi accantonati
        func sendMessageType1() {
            guard let session = self.session else { return }
            guard session.isReachable else { return }
            
            let messageToSend = ["Messaggio" : messaggio]
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
            let messageToSend = ["Messaggio" : messaggio]
            session.transferUserInfo(messageToSend)
            print("Send")
        }
        
        func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
            DispatchQueue.main.async {
                self.response = userInfo["Messaggio"] as? String ?? ""
            }
        }
    
    func sendFile(url: URL)  {
        guard let session = self.session else { return }
       
        let fileManager = FileManager()
        
        
        print(fileManager.isReadableFile(atPath: url.path()))
        guard session.isReachable else { return }
        
        let sendFile = session.transferFile(url, metadata: nil)
        print(sendFile.isTransferring)
        print("Total: \(sendFile.progress.totalUnitCount) / \(sendFile.progress.totalUnitCount) ")
       
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
