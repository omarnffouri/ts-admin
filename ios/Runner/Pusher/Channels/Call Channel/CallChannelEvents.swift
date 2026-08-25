//
//  CallChannelEvents.swift
//  Runner
//
//  Created by Hashim Khan on 27/12/2024.
//


enum CallChannelEvents {
    
    case incommingCall
    case incommingCallDeclined
    case callAccepted
    case callAcceptedWhisper
    case callDeclined
    case callDeclinedWhisper
    case callEnded
    case userBueasy
    case callRinging
    case noAnswer
    
    
    public func getName() -> String {
        switch self {
        case .incommingCall: return "incomming-call"
        case .incommingCallDeclined: return "incomming-call-declined"
        case .callAccepted: return "call-accepted"
        case .callAcceptedWhisper: return "client-call-accepted"
        case .callDeclined: return "call-declined"
        case .callDeclinedWhisper: return "client-call-declined"
        case .callEnded: return "call-ended"
        case .userBueasy: return "user-bueasy"
        case .callRinging: return "call-ringing"
        case .noAnswer: return "no-answer"
        }
    }
}
