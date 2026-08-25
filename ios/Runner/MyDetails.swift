//
//  MyDetails.swift
//  Runner
//
//  Created by Hashim Khan on 03/01/2024.
//

import Foundation

class MyDetails{
    
    
    
    public static let  Token : String = "flutter.token"
    public static let  FirstName  : String = "flutter.firstName"
    public static let  LastName  : String = "flutter.lastName"
    public static let  UserId  : String = "flutter.userId"
    public static let  ModelType  : String = "flutter.modelType"
    public static let  Image  : String = "flutter.image"
    public static let  ServerUrl : String = "flutter.serverUrl"

    // realtime/agora config mirrored from the server's realtime-configuration by
    // Dart (SharedPrefrencesHelper.storeRealtimeConfiguration) and self-healed by
    // the native call path (RealtimeConfigApi.sync). Keys must match Dart's.
    public static let  AgoraAppId : String = "flutter.agoraAppId"
    public static let  RealtimeConfigVersion : String = "flutter.realtimeConfigVersion"

    // Agora app id mirrored from the server's realtime-configuration; nil when
    // blank so callers can fall back to the hardcoded per-env id.
    static func agoraAppId() -> String? {
        let value = UserDefaults.standard.string(forKey: AgoraAppId)
        return (value?.isEmpty ?? true) ? nil : value
    }

    static func realtimeConfigVersion() -> String? {
        let value = UserDefaults.standard.string(forKey: RealtimeConfigVersion)
        return (value?.isEmpty ?? true) ? nil : value
    }

    // Persist a freshly-fetched realtime config into the same Flutter prefs Dart
    // mirrors into, so a cold-start call can self-heal a rotated agora app id
    // without Dart running. Keys match those Dart writes via SharedPrefrencesHelper.
    static func storeRealtimeConfig(agoraAppId: String?, configVersion: String?) {
        let defaults = UserDefaults.standard
        if let agoraAppId = agoraAppId, !agoraAppId.isEmpty {
            defaults.set(agoraAppId, forKey: AgoraAppId)
        }
        if let configVersion = configVersion, !configVersion.isEmpty {
            defaults.set(configVersion, forKey: RealtimeConfigVersion)
        }
    }



    var token: String?
    var firstName: String?
    var lastName: String?
    var modelType: String?
    var image: String?
    var serverUrl: String?
    var userId: Int?
    
    
    
    static func loadFromSharedPrefs() -> MyDetails?{
        
        let token = UserDefaults.standard.string(forKey: Token)
        let firstName = UserDefaults.standard.string(forKey: FirstName)
        let lastName = UserDefaults.standard.string(forKey: LastName)
        let userId = UserDefaults.standard.integer(forKey: UserId)
        let modelType = UserDefaults.standard.string(forKey: ModelType)
        let image = UserDefaults.standard.string(forKey: Image)
        let serverUrl = UserDefaults.standard.string(forKey: ServerUrl)
        
        if((token ?? "").isEmpty || (userId <= 0) || (serverUrl ?? "").isEmpty){
            return nil
        } else{
            let obj = MyDetails()
            obj.token = token
            obj.firstName = firstName
            obj.lastName = lastName
            obj.userId = userId
            obj.modelType = modelType
            obj.image = image
            obj.serverUrl = serverUrl
            return obj
        }
    }
    
    
    
    static func isProduction() -> Bool{
        return ((!isStaging()) && (!isDevelopment()))
    }
    
    
    static func isDevelopment() -> Bool{
        guard let serverUrl = MyDetails.loadFromSharedPrefs()?.serverUrl else {
            return true
        }
        return serverUrl.contains("dev")
    }
    
    static func isStaging() -> Bool{
        guard let serverUrl = MyDetails.loadFromSharedPrefs()?.serverUrl else {
            return true
        }
        return serverUrl.contains("staging")
    }
    
}
