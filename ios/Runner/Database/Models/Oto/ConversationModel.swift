//
//  ConversationModel.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//


import Foundation

struct ConversationModel: Codable, Equatable {
    var id: Int?
    var lastMessagedAt: Int?
    var user: ConversationReciverModel?
    var dateTimeInHumans: String?
    var name: String?
    var chatAble: Bool?
    var status: String?
    var participants: [ParticipantModel]?
    var notificationMuted: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case lastMessagedAt = "last_messaged_at"
        case user = "receiver"
        case dateTimeInHumans = "date_time_in_humans"
        case name
        case chatAble = "chat_able"
        case status
        case participants
        case notificationMuted = "notification_muted"
    }
}



