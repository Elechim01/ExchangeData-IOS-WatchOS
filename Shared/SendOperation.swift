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
    func sendMessageType1(session: WCSession?, message: String, errorResponse: ((ExchangeDataError) -> ())?)
    func sendMessageType2(session: WCSession?, message: String, errorResponse: ((ExchangeDataError) -> ())?)  -> WCSessionUserInfoTransfer?
    func sendFile(session: WCSession?, file: URL, errorResponse: ((ExchangeDataError) -> ())?) -> WCSessionFileTransfer?
    func sendCounter(session: WCSession?, counter: Contatore, errorResponse: ((ExchangeDataError) -> ())?)
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
    
    func sendMessageType1(session: WCSession?, message: String, errorResponse: ((ExchangeDataError)->())?) {
        guard let session = session else {
            errorResponse?(ExchangeDataError.noSession)
            return
            
        }
        guard session.isReachable else {
            errorResponse?(ExchangeDataError.notReachable)
            return
        }
        
        let messageToSend = ["Messaggio" : message]
        do {
            try session.updateApplicationContext(messageToSend)
        } catch let error {
            print(error.localizedDescription)
            errorResponse?(ExchangeDataError.generic(description: error.localizedDescription))
        }
    }
    
    func sendMessageType2(session: WCSession?, message: String, errorResponse: ((ExchangeDataError) -> ())?) -> WCSessionUserInfoTransfer? {
        guard let session = session else {
            errorResponse?(ExchangeDataError.noSession)
            return nil
        }
        guard session.isReachable else {
            errorResponse?(ExchangeDataError.notReachable)
            return nil
        }
        let messageToSend = ["Messaggio" : message]
        return session.transferUserInfo(messageToSend)
    }
    
    func sendFile(session: WCSession?,file: URL, errorResponse: ((ExchangeDataError) -> ())?) -> WCSessionFileTransfer? {
        guard let session = session else {
            errorResponse?(ExchangeDataError.noSession)
            return nil
            
        }
        let fileManager = FileManager()
        
        print(fileManager.isReadableFile(atPath: file.path()))
        guard session.isReachable else {
            errorResponse?(ExchangeDataError.notReachable)
            return  nil
        }
        
      let transfer = session.transferFile(file, metadata: nil)
      
        print(transfer.isTransferring)
        print("Total: \(transfer.progress.totalUnitCount) / \(transfer.progress.totalUnitCount) ")
        return transfer
    }
    
    func sendCounter(session: WCSession?, counter: Contatore, errorResponse: ((ExchangeDataError) -> ())?) {
        guard let session = session else {
            errorResponse?(ExchangeDataError.noSession)
            return
        }
        guard session.isReachable else {
            errorResponse?(ExchangeDataError.notReachable)
            return
        }
        do {
            let result = try JSONEncoder().encode(counter)
            session.sendMessageData(result,replyHandler: nil){ error in
                errorResponse?(ExchangeDataError.generic(description: error.localizedDescription))
            }
        } catch  {
            errorResponse?(ExchangeDataError.generic(description: error.localizedDescription))
        }
    }
    
}
