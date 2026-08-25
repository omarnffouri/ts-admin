package com.transport_system.ts_admin.pusher.channels.call_channel.events

import android.annotation.SuppressLint
import android.content.Context
import com.google.gson.Gson
import com.pusher.client.channel.PrivateChannel
import com.pusher.client.channel.PusherEvent
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.pusher.channels.call_channel.channel.CallChannel
import com.transport_system.ts_admin.pusher.channels.call_channel.enums.CallChannelEvents
import com.transport_system.ts_admin.pusher.channels.call_channel.models.CallEventDataModel
import com.transport_system.ts_admin.pusher.interfaces.PusherPrivateChannelEventListener


class CallAcceptedWhisperEvent private constructor(private val context: Context) : PusherPrivateChannelEventListener() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        @Volatile
        private var instance: CallAcceptedWhisperEvent? = null

        fun initialize(context: Context): CallAcceptedWhisperEvent {
            val appContext = context.applicationContext
            return instance ?: synchronized(this) {
                instance ?: CallAcceptedWhisperEvent(appContext).also { instance = it }
            }
        }

        fun getInstance(): CallAcceptedWhisperEvent {
            return instance ?: throw IllegalStateException("CallAcceptedWhisperEvent is not initialized. Call initialize(context) first.")
        }
    }

    override fun getChannel(): PrivateChannel? {
        return CallChannel.instance.getCallChannel(context = context)
    }

    override fun getEventName(): String {
        return CallChannelEvents.CALL_ACCEPTED_WHISPER.getName()
    }

    override fun onEvent(event: PusherEvent?) {
        try {
            AppLogger.log("Got a call accepted whisper event data : ${event?.data}")
            val callPayload = AgoraManager.instance.callViewModel.currentCall.value?.callPayload ?: return
            val data = Gson().fromJson(event!!.data, CallEventDataModel::class.java)
            if(data.conversationId != null && data.conversationId == callPayload.conversationId){
                context.sendBroadcast(CallBroadcastReceiver.buildBroadcastIntent(context = context, action = CallBroadcastActions.ACTION_CALL_INCOMING_ALREADY_ACCEPTED, data = callPayload.toBundle()))
            }
            AppLogger.log("Call accepted whisper event parsed successfully")
        }
        catch (e:Exception){
            AppLogger.log("Exception on event received in accept call whisper event ===> ${e.message}")
        }
    }
}