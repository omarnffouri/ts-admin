package com.transport_system.ts_admin.telecom.models

import java.util.Date
import java.util.UUID

class Call(
    var uuid: UUID,
    var callPayload: CallPayload,
    var isOutGoing: Boolean,
    var wasJoiningOngoingCall : Boolean = false,
) {

    private var connectingDate: Date? = null
    private var connectedDate: Date? = null



    var hasStartedConnecting: Boolean
        get() = connectingDate != null
        set(value) {
            connectingDate = if (value) Date() else null
        }


    var hasConnected: Boolean
        get() = connectedDate != null
        set(value) {
            connectedDate = if (value) Date() else null
        }


    fun callStarted() {
        if (!hasStartedConnecting) {
            hasStartedConnecting = true
        }
    }

    fun callAccepted() {
        if (!hasStartedConnecting) {
            hasStartedConnecting = true
        }
    }

    fun callConnected() {
        if (!hasConnected) {
            hasConnected = true
        }
    }

}