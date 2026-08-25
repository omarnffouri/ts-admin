//
//  DatabasePathFinderExtensions.swift
//  Runner
//
//  Created by Hashim Khan on 16/12/2024.
//

extension DatabaseManager {
    
    
    
    //
    // function to get the OTO conversations DB path
    func getOtoConversationsDatabasePath() -> String? {
        guard let documentDirectory = getDocumentDirectorPath() else{
            return nil
        }
        return documentDirectory.appendingPathComponent(DatabaseManager.OtoConversationsDatbaseName).path
    }
    
    //
    // function to get the Group Conversations DB path
    func getGroupConversationsDatabasePath() -> String? {
        guard let documentDirectory = getDocumentDirectorPath() else{
            return nil
        }
        return documentDirectory.appendingPathComponent(DatabaseManager.GroupConversationsDatbaseName).path
    }
    
    
    //
    // function to get the Documents directory URL in system
    func getDocumentDirectorPath() -> URL? {
         let  directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if(directories.isEmpty){
            return nil
        }
        return directories.first
    }
}
