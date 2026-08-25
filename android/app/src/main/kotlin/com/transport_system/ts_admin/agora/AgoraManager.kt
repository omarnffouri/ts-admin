package com.transport_system.ts_admin.agora

import android.annotation.SuppressLint
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.SurfaceView
import android.widget.Toast
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.viewModelScope
import com.google.gson.Gson
import com.transport_system.ts_admin.activities.CallActivity
import com.transport_system.ts_admin.agora.apis.AgoraTokenApi
import com.transport_system.ts_admin.agora.apis.RealtimeConfigApi
import com.transport_system.ts_admin.agora.enums.CallState
import com.transport_system.ts_admin.agora.extensions.AgoraEventHandlers
import com.transport_system.ts_admin.agora.models.CallViewModel
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.data_providers.MyDetails
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.helpers.CallEventHelper
import com.transport_system.ts_admin.native_calling_plugin.NativeCallingEventChannel
import com.transport_system.ts_admin.native_calling_plugin.NativeCallingEvents
import com.transport_system.ts_admin.notification_managers.AppNotificationManager
import com.transport_system.ts_admin.notification_managers.OngoingCallNotificationService
import com.transport_system.ts_admin.pusher.channels.call_channel.channel.CallChannel
import com.transport_system.ts_admin.telecom.models.Call
import com.transport_system.ts_admin.telecom.models.CallPayload
import com.transport_system.ts_admin.telecom.service.CallConnection
import io.agora.rtc2.ChannelMediaOptions
import io.agora.rtc2.Constants
import io.agora.rtc2.RtcEngine
import io.agora.rtc2.video.VideoCanvas
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.UUID

class AgoraManager : ViewModelStoreOwner {

    private var rtcEngine: RtcEngine? = null
    private var currentAppId: String? = null
    val callViewModel: CallViewModel by lazy {
        ViewModelProvider(this)[CallViewModel::class.java]
    }

    // ViewModelStore to manage ViewModel instances
    override val viewModelStore = ViewModelStore()


    companion object {
        val instance = AgoraManager()
    }

    // Prefer the server-synced agora app id (mirrored into prefs by Dart on
    // login and self-healed by RealtimeConfigApi.sync on the call path), else the
    // hardcoded per-env id so a call never blocks on a missing/failed config.
    private fun getAppId(context: Context): String {
        MyDetails.agoraAppId(context)?.let { return it }
        return if (MyDetails.isProduction(context)) "b7bfc1ea224b4dc79d2a0fec4b45eb51" else "56ce6ab15eef486aa7b5b798c930042e"
    }

    private fun initializeAgora(context: Context) {
        val desiredAppId = getAppId(context = context)
        // If the server rotated the agora app id (synced into prefs just before
        // this call), the existing engine still holds the old id and its token
        // would mismatch — rebuild it with the fresh id.
        if (rtcEngine != null && currentAppId != desiredAppId) {
            destroy()
        }
        if (rtcEngine == null) {
            rtcEngine = RtcEngine.create(context, desiredAppId, AgoraEventHandlers(this))
            currentAppId = desiredAppId
        }
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Channel related function ////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

    private fun joinChannel(
        context: Context,
        token: String,
        channelName: String,
        pid: Int
    ): Boolean {
        initializeAgora(context = context)

        val currentCall = callViewModel.currentCall.value

        if (currentCall?.callPayload?.callType == "audio") {
            rtcEngine?.setEnableSpeakerphone(false)
            callViewModel.enableSpeaker(false)
            rtcEngine?.enableAudio()
        }
        else if(currentCall?.callPayload?.callType == "video"){
            rtcEngine?.setEnableSpeakerphone(true)
            callViewModel.enableSpeaker(true)
            rtcEngine?.enableVideo()
            rtcEngine?.enableAudio()
        }



        val options = ChannelMediaOptions().apply {
            autoSubscribeAudio = true
            autoSubscribeVideo = true
            clientRoleType = Constants.CLIENT_ROLE_BROADCASTER
            channelProfile = Constants.CHANNEL_PROFILE_COMMUNICATION
            publishCameraTrack = currentCall?.callPayload?.callType == "video"
            publishMicrophoneTrack = true
        }
        AppLogger.log("Joining agora channel with pid : $pid, token : $token")
        return rtcEngine?.joinChannel(token, channelName, pid, options) == 0
    }

    // Refresh the realtime config (agora app id) before minting the token +
    // joining, so a rotated app id is applied and matches the freshly-signed
    // token. Shared by the accept + place call paths.
    private fun syncTokenAndJoin(
        context: Context,
        callPayload: CallPayload,
        isOutgoing: Boolean,
    ) {
        val channelName = callPayload.channelName!!
        val myPid = callViewModel.myPid.value!!
        RealtimeConfigApi.sync(context = context) {
            AgoraTokenApi.getAgoraToken(
                context = context,
                role = "attendee",
                channelName = channelName,
                pid = myPid
            ) { token ->
                AppLogger.log("Got agora token in agora manager ===> $token")
                if (token != null) {
                    joinChannel(
                        context = context,
                        token = token,
                        channelName = channelName,
                        pid = myPid
                    )
                    startOngoingCallService(
                        context = context,
                        callPayload = callPayload,
                        isOutgoing = isOutgoing,
                    )
                } else {
                    callFailed()
                }
            }
        }
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Incoming call related function //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

    fun incomingCallAccepted(context: Context, callId: UUID) {
        AppLogger.log("Call accepted in agora manager")

        initializeAgora(context = context)

        callViewModel.viewModelScope.launch {
            val result = callViewModel.incomingCallAccepted(context = context, callId = callId)
            withContext(Dispatchers.Main) {
                AppLogger.log("All data loaded successfully from the local DB using co routines and suspended functions ===> $result")
                if (result) {
                    try {


                        callViewModel.currentCall.value?.callAccepted()

                        val callPayload = callViewModel.currentCall.value!!.callPayload

                        if(callViewModel.currentCall.value?.wasJoiningOngoingCall == true){
                            scheduleTimeOutForJoiningOngoingCall(context = context, callPayload = callPayload)
                        }

                        launchCallScreen(context = context, callPayload = callPayload)
                        emitCallAcceptedEvents(
                            context = context,
                            callPayload = callPayload
                        )

                        syncTokenAndJoin(
                            context = context,
                            callPayload = callPayload,
                            isOutgoing = false,
                        )
                    } catch (e: Exception) {
                        e.printStackTrace()
                        Toast.makeText(
                            context,
                            "Unknown error occurred while accepting call.",
                            Toast.LENGTH_LONG
                        ).show()
                    }
                } else {
                    callFailed()
                    Toast.makeText(
                        context,
                        "Unknown error occurred while loading call details.",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
        }
    }

    fun clearIncomingCall(callId: UUID) {
        AppLogger.log("Incoming call clear in agora manager")
        resetSelf()
        callViewModel.clearIncomingCall(callId = callId)
    }

    fun reportIncomingCall(context: Context, call: Call) {
        AppLogger.log("Call incoming reported in agora manager")
        resetSelf()
        initializeAgora(context = context)
        callViewModel.reportIncomingCall(call = call)
    }

    private fun emitCallAcceptedEvents(context: Context, callPayload: CallPayload) {
        try {
            CallChannel.instance.getCallChannel(context = context)?.trigger(
                "client-call-accepted",
                Gson().toJson(
                    mapOf(
                        "calledBy" to mapOf(
                            "userId" to callPayload.callerId,
                            "userModelType" to callPayload.callerModelType,
                            "userName" to callPayload.callerName,
                            "userImage" to callPayload.callerImage
                        ),
                        "conversationId" to callPayload.conversationId,
                        "isOnCall" to "mobile"
                    )
                )
            )
        } catch (e: Exception) {
            AppLogger.log("Exception while triggering a call accepted event on call channel in agora manage -> emitCallAcceptedEvents ===> ${e.message}")
        }


        try {
            CallEventHelper.callAccepted(payload = callPayload,context = context)
        } catch (e: Exception) {
            AppLogger.log("Exception while triggering a call accepted api in agora manage -> emitCallAcceptedEvents ===> ${e.message}")
        }
    }

    private fun scheduleTimeOutForJoiningOngoingCall(context: Context, callPayload: CallPayload){
        try{
            Handler(Looper.getMainLooper()).postDelayed({
                context.sendBroadcast(
                    CallBroadcastReceiver.buildBroadcastIntent(
                        context = context,
                        CallBroadcastActions.ACTION_CALL_ONGOING_TIMEOUT,
                        data = callPayload.toBundle()
                    )
                )
            }, 10000)
        }
        catch (e:Exception){
            AppLogger.log("Exception while scheduling a timeout for joining ongoing call function ===> ${e.message}")
        }
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Outgoing call related function //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////


    fun placeCall(context: Context, call: Call) {
        AppLogger.log("Call place reported in agora manager")
        resetSelf()
        initializeAgora(context = context)

        callViewModel.viewModelScope.launch {
            val result = callViewModel.placeCall(context = context ,call = call)

            withContext(Dispatchers.Main) {
                AppLogger.log("All data loaded successfully from the local DB using co routines and suspended functions ===> $result")
                if (result) {
                    try {

                        callViewModel.currentCall.value?.callStarted()

                        val callPayload = callViewModel.currentCall.value!!.callPayload
                        callPayload.receiverImage = callViewModel.getReceiverImage()

                        launchCallScreen(context = context, callPayload = callPayload)

                        syncTokenAndJoin(
                            context = context,
                            callPayload = callPayload,
                            isOutgoing = true,
                        )
                    } catch (e: Exception) {
                        e.printStackTrace()
                        Toast.makeText(
                            context,
                            "Unknown error occurred while accepting call.",
                            Toast.LENGTH_LONG
                        ).show()
                    }
                } else {
                    callFailed()
                    Toast.makeText(
                        context,
                        "Unknown error occurred while loading call details.",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
        }

    }

    fun clearOutGoingCall(callId: UUID, callState: CallState){
        AppLogger.log("Outgoing call state ==> ${callState.getName()} in agora manager")
        callViewModel.updateOutGoingCallStatus(callId = callId, callState = callState)
        Handler(Looper.getMainLooper()).postDelayed({
            callViewModel.resetSelf()
        }, 2000)
        resetSelf()
    }



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Call controls related function //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

    fun toggleAudioMute() {
        val mute = !(callViewModel.audioMuted.value ?: false)
        callViewModel.muteAudio(mute = mute)
        rtcEngine?.muteLocalAudioStream(mute)
    }

    fun toggleVideoMute() {
        val mute = !(callViewModel.videoMuted.value ?: false)
        callViewModel.muteVideo(mute = mute)
        rtcEngine?.muteLocalVideoStream(mute)
    }

    fun toggleSpeakerEnable() {
        val enabled = !(callViewModel.speakerEnabled.value ?: false)
        callViewModel.enableSpeaker(enabled = enabled)
        rtcEngine?.setEnableSpeakerphone(enabled)
    }

    fun switchCamera() {
        rtcEngine?.switchCamera()
    }

    // called from BC, don't call direct
    fun endCall() {
        rtcEngine?.leaveChannel()
        resetSelf()
        callViewModel.endCall()
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Call notification related function ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

    @SuppressLint("MissingPermission")
    fun updateCallTimeInNotification(
        callPayload: CallPayload?,
        hours: Int?,
        minutes: Int?,
        seconds: Int?,
        isOutgoing : Boolean,
    ) {
        try {

            if (callPayload == null || hours == null || minutes == null || seconds == null) {
                return
            } else if (hours <= 0 && minutes <= 0 && seconds <= 0) {
                return
            }

            val context = CallConnection.currentConnection?.context ?: return

            var timeString = ""
            if (hours > 0) {
                if (hours < 10) {
                    timeString += "0"
                }
                timeString += "$hours : "
            }
            if (minutes < 10) {
                timeString += "0"
            }
            timeString += "$minutes : "
            if (seconds < 10) {
                timeString += "0"
            }
            timeString += seconds.toString()


            val notificationManager = AppNotificationManager(context = context)
            val notification =
                notificationManager.buildOngoingCallNotification(
                    callPayload = callPayload,
                    callTimeString = timeString,
                    isOutGoing = isOutgoing,
                )

            notificationManager.getNotificationManager().notify(AppNotificationManager.ONGOING_CALL_NOTIFICATION_ID,notification)

        } catch (e: Exception) {
            AppLogger.log("Exception while updating the call time in notification ===> ${e.message}")
        }
    }


    @SuppressLint("MissingPermission")
    fun updateCallStateInNotification(
        callPayload: CallPayload?,
        callState: CallState,
        isOutgoing : Boolean,
    ) {
        try {
            if (callPayload == null) {
                return
            }
            val context = CallConnection.currentConnection?.context ?: return
            val notificationManager = AppNotificationManager(context = context)
            val notification =
                notificationManager.buildOngoingCallNotification(
                    callPayload = callPayload,
                    callTimeString = callState.getName(),
                    isOutGoing = isOutgoing,
                )
            notificationManager.getNotificationManager().notify(AppNotificationManager.ONGOING_CALL_NOTIFICATION_ID,notification)
        } catch (e: Exception) {
            AppLogger.log("Exception while updating the call status in notification ===> ${e.message}")
        }
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Agora related function //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////


    fun setupLocalVideoView(surfaceView: SurfaceView) {
        try {
            rtcEngine?.setupLocalVideo(VideoCanvas(surfaceView, VideoCanvas.RENDER_MODE_HIDDEN, 0))
        } catch (e: Exception) {
            AppLogger.log("Exception while setting up local video view in agora ===> ${e.message}")
        }
    }

    fun setupRemoteVideoView(surfaceView: SurfaceView, uid: Int) {
        try {

            rtcEngine?.setupRemoteVideo(
                VideoCanvas(
                    surfaceView,
                    VideoCanvas.RENDER_MODE_HIDDEN,
                    uid
                )
            )
        } catch (e: Exception) {
            AppLogger.log("Exception while setting up local video view in agora ===> ${e.message}")
        }
    }

    fun refreshAgoraToken() {
        try {
            val context = CallConnection.currentConnection?.context ?: return
            val channelName = callViewModel.currentCall.value?.callPayload?.channelName
                ?: return
            val myPid = callViewModel.myPid.value ?: return

            AppLogger.log("Details are completed for refreshing agora token ===> channel-name : $channelName, my-pid : $myPid")

            AgoraTokenApi.getAgoraToken(
                context = context,
                channelName = channelName,
                role = "attendee",
                pid = myPid
            ) { token ->
                if (!token.isNullOrEmpty()) {
                    rtcEngine?.renewToken(token)
                    AppLogger.log("Agora token refreshed successfully.")
                } else {
                    AppLogger.log("Got a null or empty token for refreshing agora token.")
                }
            }
        } catch (e: Exception) {
            AppLogger.log("Exception on refreshing agora token ===> ${e.message}")
        }
    }

    fun launchCallScreen(context: Context, callPayload: CallPayload) {
        try {
            val intent = CallActivity.getIntent(
                callPayload.toBundle(),
                forIncomingCallNotification = false,
                fromCallAccept = true
            )
            context.startActivity(intent)
        } catch (e: Exception) {
            AppLogger.log("Failed to launch the call screen activity ===> ${e.message}")
        }
    }

    private fun startOngoingCallService(context: Context, callPayload: CallPayload, isOutgoing: Boolean) {
        try {
            OngoingCallNotificationService.start(context = context, callPayload = callPayload, isOutgoing = isOutgoing)
        } catch (e: Exception) {
            AppLogger.log("Exception while starting the ongoing call notification service ===> ${e.message}")
        }
    }

    private fun stopOngoingCallNotification(){
        val context = CallConnection.currentConnection?.context ?: return
        try {
            OngoingCallNotificationService.stop(context = context)
        } catch (e: Exception) {
            AppLogger.log("Exception while stopping the ongoing call notification service in agora manager ===> ${e.message}")
        }
    }

    fun callFailed() {
        try {
            callViewModel.callFailed()
            stopOngoingCallNotification()
            NativeCallingEventChannel.instance.sendEvent(
                event = NativeCallingEvents.CALL_FAILED,
                data = callViewModel.currentCall.value?.callPayload?.toMap()
            )
            Handler(Looper.getMainLooper()).postDelayed({
                CallConnection.destroyCurrentConnection()
                callViewModel.resetSelf()
                resetSelf()
            }, 2000)

        } catch (e: Exception) {
            AppLogger.log("Exception in function -> failedToLoadRequiredData : ${e.message}")
        }
    }

    private fun resetSelf() {
        destroy()
    }

    private fun destroy() {
        rtcEngine?.let {
            RtcEngine.destroy()
            rtcEngine = null
            currentAppId = null
        }
    }

}
