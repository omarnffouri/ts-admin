package com.transport_system.ts_admin.data_providers.models.oto

import com.google.gson.annotations.SerializedName
import com.transport_system.ts_admin.data_providers.models.common.ParticipantModel

data class ConversationModel(
    val id: Int?,
    @SerializedName("last_messaged_at") val lastMessagedAt: Int?,
    @SerializedName("receiver") val user: ConversationReceiverModel?,
    @SerializedName("date_time_in_humans") val dateTimeInHumans: String?,
    val name: String?,
    @SerializedName("chat_able") val chatAble: Boolean?,
    val status: String?,
    val participants: List<ParticipantModel>?,
    @SerializedName("notification_muted") val notificationMuted: Boolean?
)