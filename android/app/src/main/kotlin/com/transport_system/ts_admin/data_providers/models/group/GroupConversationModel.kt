package com.transport_system.ts_admin.data_providers.models.group

import com.google.gson.annotations.SerializedName

data class GroupConversationModel(
    val id: Int?,
    val name: String?,
    val conversations: List<GroupInnerConversationModel>?,
    @SerializedName("unread_count") val unreadCount: Int?,
    @SerializedName("conversations_count") val conversationsCount: Int?,
    @SerializedName("group_setting") val groupSettings: GroupSettingsModel?
)
