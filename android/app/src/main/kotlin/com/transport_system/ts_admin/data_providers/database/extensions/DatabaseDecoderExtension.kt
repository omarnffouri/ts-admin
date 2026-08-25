package com.transport_system.ts_admin.data_providers.database.extensions

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.transport_system.ts_admin.data_providers.models.group.GroupInnerConversationModel
import com.transport_system.ts_admin.data_providers.models.group.GroupSettingsModel
import com.transport_system.ts_admin.data_providers.models.oto.ConversationModel
import com.transport_system.ts_admin.helpers.AppLogger
import java.lang.reflect.Type


fun decodeOtoConversation(jsonString: String): ConversationModel? {
    return try {
        val gson = Gson()
        gson.fromJson(jsonString, ConversationModel::class.java)
    } catch (e: Exception) {
        println("Error decoding conversation JSON: ${e.message}")
        null
    }
}



fun decodeGroupInnerConversations(jsonString: String): List<GroupInnerConversationModel>? {
    try {
        val gson = Gson()
        val type: Type = TypeToken.getParameterized(List::class.java, GroupInnerConversationModel::class.java).type
        return gson.fromJson(jsonString, type)
    } catch (e: Exception) {
        AppLogger.log("Error decoding group inner conversation list JSON ===> ${e.message}")
        return null
    }
}


fun decodeGroupSettings(jsonString: String): GroupSettingsModel? {
    return try {
        val gson = Gson()
        gson.fromJson(jsonString, GroupSettingsModel::class.java)
    } catch (e: Exception) {
        AppLogger.log("Error decoding group settings JSON: ${e.message}")
        null  // Return null if any exception occurs
    }
}