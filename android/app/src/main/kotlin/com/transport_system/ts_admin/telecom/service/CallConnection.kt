package com.transport_system.ts_admin.telecom.service

import android.annotation.SuppressLint
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.telecom.Connection
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.helpers.RingtoneHelper
import com.transport_system.ts_admin.notification_managers.AppNotificationChannelManager
import com.transport_system.ts_admin.notification_managers.CallNotificationService
import com.transport_system.ts_admin.pusher.channels.call_channel.channel.CallChannel
import com.transport_system.ts_admin.pusher.manager.PusherManager
import com.transport_system.ts_admin.telecom.models.Call

class CallConnection(val context: Context, val call : Call) : Connection() {



    companion object{
        @SuppressLint("StaticFieldLeak")
        var currentConnection: CallConnection? = null


        fun destroyCurrentConnection(){
            try{
                currentConnection?.onAbort()
                currentConnection?.destroy()
                currentConnection = null
            }
            catch (e:Exception){
                AppLogger.log("Exception on destroyCurrentConnection method in connection service ===> ${e.message}")
            }
        }
    }


    init {
        // initializing pusher and call channel
        PusherManager.instance.initialize(context = context)
        CallChannel.instance.initialize(context = context)
    }



    override fun onAbort() {
        super.onAbort()
        AppLogger.log("On abort called in call connection")
    }

    private fun scheduleTimeOut(action: CallBroadcastActions){
        Handler(Looper.getMainLooper()).postDelayed({
            context.sendBroadcast(
                CallBroadcastReceiver.buildBroadcastIntent(
                    context = context,
                    action,
                    data = extras
                )
            )
        }, 30000)
    }


    override fun onShowIncomingCallUi() {
        super.onShowIncomingCallUi()

        try{

            if(call.isOutGoing){
                AgoraManager.instance.placeCall(context =context, call = call)
                scheduleTimeOut(action = CallBroadcastActions.ACTION_CALL_OUTGOING_TIMEOUT)
                return
            }


            if(!AppNotificationChannelManager().ensureIncomingCallNotificationChannel(context)){
                destroyCurrentConnection()
                return
            }
            val startedSuccessfully = CallNotificationService.start(context = context, callPayload = call.callPayload )
            if(startedSuccessfully){
                scheduleTimeOut(action = CallBroadcastActions.ACTION_CALL_INCOMING_TIMEOUT)
                AgoraManager.instance.reportIncomingCall(context = context, call = call)
            }
            else{
                destroyCurrentConnection()
            }
        }
        catch (e:Exception){
            destroyCurrentConnection()
            AppLogger.log("Exception on onShowIncomingCallUi method in connection service ===> ${e.message}")
        }
    }


    override fun onSilence() {
        super.onSilence()
        RingtoneHelper.stopRingtone()
    }

}
