package com.transport_system.ts_admin.network.models

import com.google.gson.annotations.SerializedName

// Mirrors GET admin/realtime-configuration. Only the fields the native call
// layer needs to refresh are modelled (the agora app id); the server's agora
// secrets and websocket block are intentionally not pulled into native here.
data class RealtimeConfigResponse(
    val data: RealtimeConfigData?
)

data class RealtimeConfigData(
    val agora: AgoraConfig?,
    @SerializedName("config_version") val configVersion: String?
)

data class AgoraConfig(
    @SerializedName("app_id") val appId: String?
)
