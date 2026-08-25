package com.transport_system.ts_admin.data_providers.database

import android.content.Context
import com.transport_system.ts_admin.data_providers.database.extensions.decodeGroupInnerConversations
import com.transport_system.ts_admin.data_providers.database.extensions.decodeGroupSettings
import com.transport_system.ts_admin.data_providers.database.extensions.decodeOtoConversation
import com.transport_system.ts_admin.data_providers.database.extensions.getGroupDatabase
import com.transport_system.ts_admin.data_providers.database.extensions.getOtoDatabase
import com.transport_system.ts_admin.data_providers.models.group.GroupConversationModel
import com.transport_system.ts_admin.data_providers.models.group.GroupInnerConversationModel
import com.transport_system.ts_admin.data_providers.models.oto.ConversationModel
import com.transport_system.ts_admin.helpers.AppLogger
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext


class DatabaseManager {

    companion object{
        val instance = DatabaseManager()

        // database names
        const val OTO_CONVERSATIONS_DATABASE_NAME = "conversations_database.db"
          const val GROUP_CONVERSATIONS_DATABASE_NAME = "group_conversations_database.db"

        //
        // table names
        const val OTO_CONVERSATIONS_TABLE_NAME = "conversations"
         const val GROUP_CONVERSATIONS_TABLE_NAME = "group_conversations"

    }

    //
    //
    //function to fetch the specific conversation with ID
    suspend fun fetchOtoConversation(conversationId: Int?, context: Context): ConversationModel? {
        if (conversationId == null) {
            AppLogger.log("nil conversationId passed in fetchOtoConversation")
            return null
        }
        return withContext(Dispatchers.IO){
            val db = getOtoDatabase(context = context) ?: return@withContext null
             try {
                val query = "SELECT * FROM $OTO_CONVERSATIONS_TABLE_NAME WHERE conversation_id = ?;"
                val cursor = db.rawQuery(query, arrayOf(conversationId.toString())).use { cursor ->
                    var conversation: ConversationModel? = null
                    if (cursor.moveToFirst()) {
                        val conversationJsonString = cursor.getString(2)
                        conversation = conversationJsonString?.takeIf { it.isNotEmpty() }
                            ?.let { decodeOtoConversation(it) }
                    }
                    conversation
                }
                cursor
            } catch (e: Exception) {
                AppLogger.log("Error fetching OTO conversation ===> ${e.message}")
                null
            } finally {
                db.close()
            }
        }
    }

    //
    //
    // function to fetch the specific inner conversation from the group with ID
    suspend fun fetchGroupInnerConversation(conversationId: Int?, context: Context): GroupInnerConversationModel? {
        if (conversationId == null) {
            AppLogger.log("nil conversationId passed in fetchGroupInnerConversation")
            return null
        }
        return withContext(Dispatchers.IO){
            val db = getGroupDatabase(context) ?: return@withContext null
             try {
                db.rawQuery("SELECT * FROM $GROUP_CONVERSATIONS_TABLE_NAME", null)?.use { cursor ->
                    var conversation: GroupInnerConversationModel? = null
                    while (cursor.moveToNext()) {
                        try {
                            val jsonString = cursor.getString(2)
                            val conversations = decodeGroupInnerConversations(jsonString)
                            conversation = conversations?.firstOrNull { it.id == conversationId }
                            if (conversation != null) {
                                break
                            }
                        } catch (e: Exception) {
                            AppLogger.log("Error decoding conversation JSON or processing cursor: ${e.message}")
                        }
                    }
                    conversation
                }
            } catch (e: Exception) {
                AppLogger.log("Error during database query execution in fetchGroupInnerConversation: ${e.message}")
                null
            } finally {
                try {
                    db.close()
                } catch (e: Exception) {
                    AppLogger.log("Error closing database in fetchGroupInnerConversation: ${e.message}")
                }
            }
        }
    }

    //
    //
    // function to fetch the specific group contains a conversations ID
    suspend fun fetchGroupDetails(conversationId: Int?, context: Context): GroupConversationModel? {
        if (conversationId == null) {
            AppLogger.log("nil conversationId passed in fetchGroupDetails")
            return null
        }
        return withContext(Dispatchers.IO){
            val db = getGroupDatabase(context = context) ?: return@withContext null
            var group: GroupConversationModel? = null
             try {
                db.rawQuery("SELECT * FROM $GROUP_CONVERSATIONS_TABLE_NAME", null).use { cursor ->
                    // Loop through the cursor rows
                    while (cursor.moveToNext()) {
                        try {
                            val conversationsJsonString = cursor.getString(2)
                            val conversations = decodeGroupInnerConversations(conversationsJsonString)
                            if (conversations != null) {
                                val found = conversations.firstOrNull { it.id == conversationId }
                                if (found != null) {
                                    group = GroupConversationModel(
                                        id = cursor.getInt(0),
                                        name = cursor.getString(1),
                                        conversations = conversations,
                                        conversationsCount = cursor.getInt(4),
                                        unreadCount = cursor.getInt(5),
                                        groupSettings = cursor.getString(3)?.let { groupSettingsJsonString ->
                                            decodeGroupSettings(groupSettingsJsonString)
                                        }
                                    )
                                    break
                                }
                            }
                        } catch (e: Exception) {
                            AppLogger.log("Error processing cursor row: ${e.message}")
                        }
                    }
                    group
                }
            }
            catch (e:Exception){
                AppLogger.log("Error during database query execution in fetchGroupDetails: ${e.message}")
                null
            }
            finally {
                try {
                    db.close()
                } catch (e: Exception) {
                    AppLogger.log("Error closing database in fetchGroupDetails: ${e.message}")
                }
            }
        }
    }

}