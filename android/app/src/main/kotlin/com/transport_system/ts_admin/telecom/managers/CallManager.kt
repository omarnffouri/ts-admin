package com.transport_system.ts_admin.telecom.managers

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.telecom.TelecomManager
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.telecom.models.Call
import com.transport_system.ts_admin.telecom.models.CallPayload
import com.transport_system.ts_admin.telecom.service.CallConnection

class CallManager(private val context: Context) {



    fun reportIncommingCall(callPayload: CallPayload){
        val telecomManager = PhoneAccountManager.getTelecomManager(context = context)
        val phoneAccountHandle = PhoneAccountManager.getPhoneAccountHandler(context = context)

        val uri = Uri.fromParts("tel", callPayload.callerName ?: "", null)
        val bundle = Bundle().apply {
            putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, phoneAccountHandle)
            putParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS, uri)
            putBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS, callPayload.toBundle())
        }
        telecomManager.addNewIncomingCall(phoneAccountHandle, bundle)
    }


    @SuppressLint("MissingPermission")
    fun placeCall(call: Call){
        try{
            val telecomManager = PhoneAccountManager.getTelecomManager(context = context)
            val phoneAccountHandle = PhoneAccountManager.getPhoneAccountHandler(context = context)
            val uri = Uri.fromParts("tel", call.callPayload.receiverName ?: "", null)
            val bundle = Bundle().apply {
                putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, phoneAccountHandle)
                putBundle(TelecomManager.EXTRA_OUTGOING_CALL_EXTRAS, call.callPayload.toBundle())
            }
            telecomManager.placeCall(uri,bundle)
        }
        catch (e:Exception){
            AppLogger.log("Exception in call manager while placing the call ===> ${e.message}")
        }
    }



    fun incomingCallDecline(callPayload: CallPayload){
        AppLogger.log("Got incomming decline notification")
        val currentCall = AgoraManager.instance.callViewModel.currentCall.value
        if (CallConnection.currentConnection != null && currentCall != null){
            AppLogger.log("Got incomming decline notification => have current connection and call")
            if(currentCall.uuid.toString() == callPayload.tempCallId){
                AppLogger.log("Got incomming decline notification ===> call temp id matched")
                //
                // send incoming declined broadcast
                val intent = CallBroadcastReceiver.buildBroadcastIntent(context = context, action = CallBroadcastActions.ACTION_CALL_INCOMING_DECLINED, data = callPayload.toBundle())
                context.sendBroadcast(intent)
            }
        }
    }
}