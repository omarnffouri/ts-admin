//
//  DatabaseManager.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//

import SQLite3
import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    //
    // database names
    static let OtoConversationsDatbaseName = "conversations_database.db"
    static let GroupConversationsDatbaseName = "group_conversations_database.db"
    
    //
    // table names
    static let OtoConversationsTableName = "conversations"
    static let GroupConversationsTableName = "group_conversations"
    
    
    
    
    
    //
    //
    // function to fetch the specific conversation with ID
    func fetchOtoConversation(conversationId: Int?) throws -> ConversationModel?  {
        
        guard let conversationId = conversationId else {
            print("nil conversationId passed in fetchOtoConversation")
            return nil
        }
        
        guard let dbPath = getOtoConversationsDatabasePath() else {
            print("Empty Database Path")
            return nil
        }
        
        var db: OpaquePointer?
        
        if (sqlite3_open(dbPath, &db) != SQLITE_OK) {
            print("Error opening database")
            return nil
        }
        
        defer {
            sqlite3_close(db)
        }
        
        let query = "SELECT * FROM \(DatabaseManager.OtoConversationsTableName) WHERE conversation_id = ?;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing query: \(String(cString: sqlite3_errmsg(db)))")
            return nil
        }
        
        sqlite3_bind_int64(statement, 1, sqlite3_int64(conversationId))
        
        var conversation: ConversationModel? = nil
        
        if sqlite3_step(statement) == SQLITE_ROW {
            if let conversationJsonString = extractJsonString(from: statement, at: 2) {
                conversation = decodeOtoConversation(from: conversationJsonString)
            }
        }
        
        sqlite3_finalize(statement)
        
        return conversation
    }
    
    
    
    //
    //
    // function to fetch the specific inner conversation from the group with ID
    func fetchGroupInnerConversation(conversationId: Int?) throws -> GroupInnerConversationModel?  {
        
        guard let conversationId = conversationId else {
            print("nil conversationId passed in fetchGroupConversation")
            return nil
        }
        
        guard let dbPath = getGroupConversationsDatabasePath() else {
            print("Empty Database Path")
            return nil
        }
        
        var db: OpaquePointer?
        
        if (sqlite3_open(dbPath, &db) != SQLITE_OK) {
            print("Error opening database")
            return nil
        }
        
        defer {
            sqlite3_close(db)
        }
        
        let query = "SELECT * FROM \(DatabaseManager.GroupConversationsTableName);"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing query: \(String(cString: sqlite3_errmsg(db)))")
            return nil
        }
        
        
        var conversation: GroupInnerConversationModel? = nil
        
        while sqlite3_step(statement) == SQLITE_ROW {
            guard let conversationsJsonString = extractJsonString(from: statement, at: 2),
                  let conversations = decodeGroupInnerConversations(from: conversationsJsonString) else {
                continue
            }
            
            if let found = conversations.first(where: { $0.id == conversationId }) {
                conversation = found
                break
            }
        }
        
        sqlite3_finalize(statement)
        
        return conversation
    }
    
    
    
    //
    //
    // function to fetch the specific group contains a conversations ID
    func fetchGroupDetails(conversationId: Int?) throws -> GroupConversationModel?  {
        
        guard let conversationId = conversationId else {
            print("nil conversationId passed in fetchGroupInnerConversation")
            return nil
        }
        
        guard let dbPath = getGroupConversationsDatabasePath() else {
            print("Empty Database Path")
            return nil
        }
        
        var db: OpaquePointer?
        
        if (sqlite3_open(dbPath, &db) != SQLITE_OK) {
            print("Error opening database")
            return nil
        }
        
        defer {
            sqlite3_close(db)
        }
        
        let query = "SELECT * FROM \(DatabaseManager.GroupConversationsTableName);"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing query: \(String(cString: sqlite3_errmsg(db)))")
            return nil
        }
        
        
        var group: GroupConversationModel? = nil
        
        while sqlite3_step(statement) == SQLITE_ROW {
            guard let conversationsJsonString = extractJsonString(from: statement, at: 2),
                  let conversations = decodeGroupInnerConversations(from: conversationsJsonString) else {
                continue
            }
            
            if conversations.first(where: { $0.id == conversationId }) != nil {
                
                group = GroupConversationModel()
                group?.id = extractInt(from: statement, at: 0)
                group?.name = extractString(from: statement, at: 1)
                group?.conversations = conversations
                group?.conversationsCount = extractInt(from: statement, at: 4)
                group?.unreadCount = extractInt(from: statement, at: 5)
                if let groupSettingsJsonString = extractJsonString(from: statement, at: 3),
                   let groupSettings = decodeGroupSettings(from: groupSettingsJsonString) {
                    group?.groupSettings = groupSettings
                }
                break
            }
        }
        
        sqlite3_finalize(statement)
        
        return group
    }
    
    
    
    
    
    
}
