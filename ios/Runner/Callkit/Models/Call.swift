//
//  Call 2.swift
//  Runner
//
//  Created by Hashim Khan on 12/12/2024.
//


import Foundation
import AVFAudio

public class Call: NSObject , ObservableObject {
    
    @Published var uuid: UUID
    @Published var callPayload : CallPayload
    @Published var isOutGoing: Bool
    
    public var handle: String?
    var connectingDate: Date?
    var connectedDate: Date?
    var endDate: Date?
    var isOnHold = false
    var isMuted = false
    var wasJoiningOngoingCall: Bool = false
    
    var hasStartedConnecting: Bool{
        get{
            return connectingDate != nil
        }
        set{
            connectingDate = newValue ? Date() : nil
        }
    }
    
    var hasConnected: Bool {
        get{
            return connectedDate != nil
        }
        set{
            connectedDate = newValue ? Date() : nil
        }
    }
    
    init(uuid: UUID, callPayload: CallPayload, isOutGoing: Bool = false, wasJoiningOngoingCall: Bool = false){
        self.uuid = uuid
        self.callPayload = callPayload
        self.isOutGoing = isOutGoing
        self.wasJoiningOngoingCall = wasJoiningOngoingCall
    }
    
    
    func callStarted(){
        guard hasStartedConnecting == false else { return }
        hasStartedConnecting = true
    }
        
    func callAccepted(){
        guard hasStartedConnecting == false else { return }
        hasStartedConnecting = true
    }
        
    func callConnected(){
        guard hasConnected == false else { return }
        hasConnected = true
    }
}
