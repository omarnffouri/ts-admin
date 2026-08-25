package com.transport_system.ts_admin.broadcast_receiver

enum class CallBroadcastActions {
    ACTION_CALL_INCOMING_TIMEOUT,
    ACTION_CALL_INCOMING_DECLINE,
    ACTION_CALL_INCOMING_ACCEPT,
    ACTION_CALL_INCOMING_RINGING,
    ACTION_CALL_ENDED,
    ACTION_CALL_INCOMING_DECLINED,
    ACTION_CALL_INCOMING_ALREADY_ACCEPTED,
    ACTION_CALL_INCOMING_ALREADY_DECLINED,

    //
    // outgoing call actions
    ACTION_CALL_OUTGOING_DECLINED,
    ACTION_CALL_OUTGOING_USER_BUSY,
    ACTION_CALL_OUTGOING_RINGING,
    ACTION_CALL_OUTGOING_TIMEOUT,
    ACTION_CALL_OUTGOING_NO_ANSWER,

    //
    // join ongoing call actions
    ACTION_CALL_ONGOING_JOIN,
    ACTION_CALL_ONGOING_TIMEOUT;

    fun getName(): String {
        return "com.transport_system.ts_admin.$this"
    }
}