package com.transport_system.ts_admin.data_providers.models.group

import com.google.gson.annotations.SerializedName
import com.transport_system.ts_admin.data_providers.models.common.ModelType
import com.transport_system.ts_admin.data_providers.models.common.ParticipantModel

data class GroupInnerConversationModel(
    val id: Int?,
    @SerializedName("group_name") val groupName: String?,
    @SerializedName("model_id") val modelId: Int?,
    @SerializedName("model_type") val modelType: ModelType?,
    val name: String?,
    val type: String?,
    val image: String?,
    val participants: List<ParticipantModel>?,
    @SerializedName("chat_able") val chatAble: Boolean?,
    val status: String?,
    @SerializedName("date_time_in_humans") val dateTimeInHumans: String?,
    @SerializedName("last_messaged_at") val lastMessagedAt: Int?,
    @SerializedName("unread_count") val unreadCount: Int?,
    val mentioned: List<Int>?,
    @SerializedName("notification_muted") val notificationMuted: Boolean?
)
