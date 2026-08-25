package com.transport_system.ts_admin.pusher.channels.call_channel.enums

enum class CallChannelEvents {
    INCOMING_CALL,
    INCOMING_CALL_DECLINED,
    CALL_ACCEPTED,
    CALL_ACCEPTED_WHISPER,
    CALL_DECLINED,
    CALL_DECLINED_WHISPER,
    CALL_ENDED,
    USER_BUSY,
    CALL_RINGING,
    NO_ANSWER;

    fun getName(): String {
        return when (this) {
            INCOMING_CALL -> "incomming-call"
            INCOMING_CALL_DECLINED -> "incomming-call-declined"
            CALL_ACCEPTED -> "call-accepted"
            CALL_ACCEPTED_WHISPER -> "client-call-accepted"
            CALL_DECLINED -> "call-declined"
            CALL_DECLINED_WHISPER -> "client-call-declined"
            CALL_ENDED -> "call-ended"
            USER_BUSY -> "user-bueasy"
            CALL_RINGING -> "call-ringing"
            NO_ANSWER -> "no-answer"
        }
    }
}
