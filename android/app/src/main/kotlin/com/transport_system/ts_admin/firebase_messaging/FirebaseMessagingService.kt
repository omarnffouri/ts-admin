package com.transport_system.ts_admin.firebase_messaging

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.util.Log
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.helpers.CallEventHelper
import com.transport_system.ts_admin.notification_managers.AppNotificationManager
import com.transport_system.ts_admin.telecom.managers.CallManager
import com.transport_system.ts_admin.telecom.models.CallPayload
import com.transport_system.ts_admin.telecom.service.CallConnection

class FirebaseMessagingService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "New token: $token")
        // Send token to your server if needed
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)


        // Check if the message contains a data payload
        remoteMessage.data.let {
            Log.d("FCM", "Message data payload: $it")
            // Handle data message
        }


        remoteMessage.data.let {
            if(it["notification_type"] == "call"){
                try {
                    val callPayload = CallPayload.fromMap(map = remoteMessage.data)

                    if (it["incomming_declined"] == "1"){
                        CallManager(context = applicationContext).incomingCallDecline(callPayload = callPayload)
                    }
                    else if (getTimeDifference(callPayload.callPlacedAt) >= 35){
                        AppNotificationManager(context = applicationContext).showMiscallNotification(callPayload = callPayload)
                    }
                    else if (CallConnection.currentConnection == null && AgoraManager.instance.callViewModel.currentCall.value == null){
                        CallManager(context = applicationContext).reportIncommingCall(callPayload = callPayload)
                    }
                    else{
                        CallEventHelper.userBusy(payload =  callPayload, context = applicationContext)
                    }
                }
                catch (e: Exception){
                    AppLogger.log("Exception while processing call notification in FirebaseMessagingService : ${e.message}")
                }
            }
        }

    }


    private fun getTimeDifference(callPlacedAt :  String?): Long {
        return try {
            val currentTime = System.currentTimeMillis()
            val callTime = callPlacedAt?.toLongOrNull()
             if (callTime != null) {
                ((currentTime - callTime) / 1000)
            } else {
                0
            }
        }
        catch (_:Exception){
             0
        }
    }
}
