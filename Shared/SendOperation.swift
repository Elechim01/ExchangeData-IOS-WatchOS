//
//  SendOperation.swift
//  ExchangeData
//
//  Created by Michele Manniello on 08/05/23.
//

import Foundation
import WatchConnectivity

protocol SendOperation {
    func sendMessage(session: WCSession?, message: String, errorResponse: ((ExchangeDataError)->())?)
    //    MARK: messaggi accantonati
        /// molteplici invi da parte di questo metdo saranno inviati sequenzialmente -> Ottimo sistema in caso di app di news
    func sendMessageType1(session: WCSession?, message: String)
    func sendMessageType2(session: WCSession?, message: String)
    func sendFile(session: WCSession?,file: URL) -> WCSessionFileTransfer?
    func sendCounter(session: WCSession?, counter: Contatore)
}

extension SendOperation {
    
    func sendMessage(session: WCSession?, message: String, errorResponse: ((ExchangeDataError)->())?) {
        guard let session = session else {
            errorResponse?(ExchangeDataError.noSession)
            return
            
        }
//    MARK: controllo che sono connesso
        guard session.isReachable else {
            errorResponse?(ExchangeDataError.notReachable)
            return
            
        }
//    MARK: send message
        let messageToSend = ["Messaggio" : message]
        session.sendMessage(messageToSend,replyHandler: nil){ error in
            errorResponse?(ExchangeDataError.generic(description: error.localizedDescription))
        }
    }
    
    func sendMessageType1(session: WCSession?, message: String) {
        guard let session = session else { return }
        guard session.isReachable else { return }
        
        let messageToSend = ["Messaggio" : message]
        do {
            try session.updateApplicationContext(messageToSend)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func sendMessageType2(session: WCSession?, message: String) {
        guard let session = session else { return }
        guard session.isReachable else { return }
        let messageToSend = ["Messaggio" : message]
        session.transferUserInfo(messageToSend)
        print("Send")
    }
    
    func sendFile(session: WCSession?,file: URL) -> WCSessionFileTransfer? {
        guard let session = session else { return nil }
        let fileManager = FileManager()
        
        print(fileManager.isReadableFile(atPath: file.path()))
        guard session.isReachable else { return  nil}
        
        let sendFile = session.transferFile(file, metadata: nil)
      
        print(sendFile.isTransferring)
        print("Total: \(sendFile.progress.totalUnitCount) / \(sendFile.progress.totalUnitCount) ")
        return sendFile
    }
    
    func sendCounter(session: WCSession?, counter: Contatore) {
        guard let session = session else { return }
        guard session.isReachable else { return }
        do {
            var result = try JSONEncoder().encode(counter)
            session.sendMessageData(result,replyHandler: nil){ error in
                print("Error: \(error.localizedDescription)")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}
