//
//  PusherManager.swift
//  Runner
//
//  Created by Hashim Khan on 17/12/2024.
//


import Foundation
import PusherSwift


class PusherManager : ObservableObject {
    
    
    static let shared = PusherManager()
    
    
    private var pusher: Pusher?
    private let pusherKey: String = "HiXzy5MIniPeS24McIZ1VdIrZ" 

    
    // MARK: - Connection Functions
    func initializePusher() {
        
        // Create the Pusher ClientOptions with the custom URL
        let clusterOptions = PusherClientOptions(
            authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: self),
            host: .host(getHost()),
            port: 2096,
            useTLS: true
        )
        
        pusher = Pusher(key: pusherKey, options: clusterOptions)
        pusher?.connection.delegate = self
        
        // Establish connection
        pusher?.connect()
    }
    
    func disconnect() {
        pusher?.disconnect()
    }
    
    func isConnected() -> Bool {
        // Connection state (post-handshake), not the raw socket.
        return pusher?.connection.connectionState == ConnectionState.connected
    }
    
    func ensureConnection() {
        if !isConnected() {
            printLog("Socket is not connected, attempting to reconnect...")
            guard let pusherInstance = pusher else {
                initializePusher()
                return
            }
            pusherInstance.connect()
        } else {
            printLog("Socket is already connected.")
        }
    }
    
    func getPusher() -> Pusher{
        guard let pusherInstance = pusher else {
            initializePusher()
            return pusher!
        }
        return pusherInstance
    }

    // MARK: - Configs Functions
    private func getHost() -> String {
        return MyDetails.isProduction() ? "socket.ts-portal.com" : "staging.ts-portal.com"
    }
    

    
    func printLog(_ message: String) {
        print("Pusher: \(message)")
    }
    
}



