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


class CallUserBusyEvent private constructor(private val context: Context) : PusherPrivateChannelEventListener() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        @Volatile
        private var instance: CallUserBusyEvent? = null

        fun initialize(context: Context): CallUserBusyEvent {
            val appContext = context.applicationContext
            return instance ?: synchronized(this) {
                instance ?: CallUserBusyEvent(appContext).also { instance = it }
            }
        }

        fun getInstance(): CallUserBusyEvent {
            return instance ?: throw IllegalStateException("CallUserBusyEvent is not initialized. Call initialize(context) first.")
        }
    }

    override fun getChannel(): PrivateChannel? {
        return CallChannel.instance.getCallChannel(context = context)
    }

    override fun getEventName(): String {
        return CallChannelEvents.USER_BUSY.getName()
    }

    override fun onEvent(event: PusherEvent?) {
        try {
            AppLogger.log("Got a call user busy event data : ${event?.data}")
            val data = Gson().fromJson(event!!.data, CallEventDataModel::class.java)
            AppLogger.log("Call user busy event parsed successfully")

            if (data.conversationType == "group") {
                return
            }

            val agoraManager = AgoraManager.instance
            val currentCall = agoraManager.callViewModel.currentCall.value ?: return
            val conversationId = currentCall.callPayload.conversationId ?: return
            if (conversationId == data.conversationId) {
                context.sendBroadcast(
                    CallBroadcastReceiver.buildBroadcastIntent(
                        context = context,
                        action = CallBroadcastActions.ACTION_CALL_OUTGOING_USER_BUSY,
                        data = currentCall.callPayload.toBundle()
                    )
                )
            }
        }
        catch (e:Exception){
            AppLogger.log("Exception on event received in call user busy event ===> ${e.message}")
        }
    }
}