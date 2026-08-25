//
//  DatabaseDecoderExtension.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//


import SQLite3

extension DatabaseManager {
    
    
    
    // Helper to extract the JSON string from a given column index
    func extractJsonString(from statement: OpaquePointer?, at index: Int32) -> String? {
        guard let columnText = sqlite3_column_text(statement, index) else {
            return nil
        }
        return String(cString: columnText)
    }
    
    // Helper to extract the string from a given column index
    func extractString(from statement: OpaquePointer?, at index: Int32) -> String? {
        guard let columnText = sqlite3_column_text(statement, index) else {
            return nil
        }
        return String(cString: columnText)
    }
    
    
    // Helper to extract the int from a given column index
    func extractInt(from statement: OpaquePointer?, at index: Int32) -> Int? {
        return Int(sqlite3_column_int(statement, index))
    }
    
    //
    // function to decode OTO conversation from a json string
    func decodeOtoConversation(from jsonString: String) -> ConversationModel? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let conversation = try JSONDecoder().decode(ConversationModel.self, from: data)
            return conversation
        } catch {
            print("Error decoding conversation JSON: \(error)")
            return nil
        }
    }
    
    //
    // function to decode Group conversation from a json string
    func decodeGroupInnerConversations(from jsonString: String) -> [GroupInnerConversationModel]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let conversation = try JSONDecoder().decode([GroupInnerConversationModel].self, from: data)
            return conversation
        } catch {
            print("Error decoding group conversation JSON: \(error)")
            return nil
        }
    }
    
    
    
    //
    // function to decode Group settings from a json string
    func decodeGroupSettings(from jsonString: String) -> GroupSettingsModel? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let groupSettings = try JSONDecoder().decode(GroupSettingsModel.self, from: data)
            return groupSettings
        } catch {
            print("Error decoding group settings JSON: \(error)")
            return nil
        }
    }
    
}
