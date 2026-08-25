//
//  GroupInnerConversationModel.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//


import Foundation

struct GroupInnerConversationModel: Codable, Equatable {
    var id: Int?
    var groupName: String?
    var modelId: Int?
    var modelType: ModelType?
    var name: String?
    var type: String?
    var image: String?
    var participants: [ParticipantModel]?
    var chatAble: Bool?
    var status: String?
    var dateTimeInHumans: String?
    var lastMessagedAt: Int?
    var unreadCount: Int?
    var mentioned: [Int]?
    var notificationMuted: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case modelId = "model_id"
        case modelType = "model_type"
        case name
        case type
        case image
        case participants
        case chatAble = "chat_able"
        case status
        case dateTimeInHumans = "date_time_in_humans"
        case lastMessagedAt = "last_messaged_at"
        case unreadCount = "unread_count"
        case mentioned
        case notificationMuted = "notification_muted"
    }
}
