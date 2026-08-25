package com.transport_system.ts_admin.data_providers.models.common

import com.google.gson.annotations.SerializedName

enum class ModelType {
    @SerializedName("users") USERS,
    @SerializedName("applicants") APPLICANTS
}