//
//  GroupConversationModel.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//


import Foundation

struct GroupConversationModel: Codable, Equatable {
    var id: Int?
    var name: String?
    var conversations: [GroupInnerConversationModel]?
    var unreadCount: Int?
    var conversationsCount: Int?
    var groupSettings: GroupSettingsModel?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case conversations
        case unreadCount = "unread_count"
        case conversationsCount = "conversations_count"
        case groupSettings = "group_setting"
    }
}
