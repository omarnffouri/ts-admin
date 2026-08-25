package com.transport_system.ts_admin.native_calling_plugin

import android.content.Context
import android.telecom.Connection
import android.telecom.TelecomManager
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.data_providers.MyDetails
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.telecom.managers.CallManager
import com.transport_system.ts_admin.telecom.models.Call
import com.transport_system.ts_admin.telecom.models.CallPayload
import com.transport_system.ts_admin.telecom.service.CallConnection
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class NativeCallingMethodChannel : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "native_calling_method_channel"
        var channel: MethodChannel? = null
    }

    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "place_call" -> {
                try {

                    if(context == null){
                        result.success(false)
                        return
                    }

                    @Suppress("UNCHECKED_CAST")
                    val arguments = call.arguments as? Map<String?, Any?> ?: run {
                        result.success(false)
                        AppLogger.log("Method arguments null on place_call native method")
                        return
                    }


                    val mappedArguments: Map<String?, Any?> = arguments
                        .filter { it.key != null && it.value != null }
                        .mapKeys { it.key as String }
                        .mapValues { it.value.toString() }

                    val callPayload = CallPayload.fromMap(mappedArguments)

                    val tempCallID = try {
                        UUID.fromString(callPayload.tempCallId)
                    } catch (e: Exception) {
                        result.success(false)
                        AppLogger.log("Exception while parsing uuid in place_call native method ===> ${e.message}")
                        return
                    }

                    CallManager(context = context!!).placeCall(call = Call(uuid = tempCallID, callPayload = callPayload, isOutGoing = true))

                    result.success(true)
                    return
                }
                catch (e:Exception){
                    AppLogger.log("Exception while placing call from a method channel ===> ${e.message}")
                    return result.success(false)
                }
            }

            "open_native_call_ui" -> {
                try {
                    val callId = call.arguments as String
                    val currentCall = AgoraManager.instance.callViewModel.currentCall.value
                    if (currentCall != null && context != null) {
                        if (currentCall.uuid.toString() == callId) {
                            AgoraManager.instance.launchCallScreen(
                                context = context!!,
                                callPayload = currentCall.callPayload
                            )
                             result.success(true)
                            return
                        }
                        else{
                            AppLogger.log("Current call id not matched with params call id in ===> open_native_call_ui")
                        }
                    }
                    else{
                        AppLogger.log("Current call or context is null in ===> open_native_call_ui")
                    }
                     result.success(false)
                    return
                } catch (e: Exception) {
                    AppLogger.log("Exception while opening a call screen in method channel ===> ${e.message}")
                     result.success(false)
                    return
                }

            }

            "end_call" -> {
                try {
                    val callId = call.arguments as String
                    val currentCall = AgoraManager.instance.callViewModel.currentCall.value
                    if (currentCall != null && context != null) {
                        if (currentCall.uuid.toString() == callId) {
                            context!!.sendBroadcast(
                                CallBroadcastReceiver.buildBroadcastIntent(
                                    context = context!!,
                                    action = CallBroadcastActions.ACTION_CALL_ENDED,
                                    data = currentCall.callPayload.toBundle()
                                )
                            )
                             result.success(true)
                            return
                        }
                        else{
                            AppLogger.log("Current call id not matched with params call id in ===> end_call")
                        }
                    }
                    else{
                        AppLogger.log("Current call or context is null in ===> end_call")
                    }
                     result.success(false)
                    return
                } catch (e: Exception) {
                    AppLogger.log("Exception while ending call from a method channel ===> ${e.message}")
                     result.success(false)
                    return
                }
            }

            "can_start_call" -> {
                 result.success(AgoraManager.instance.callViewModel.currentCall.value == null && CallConnection.currentConnection == null)
                return
            }


            "get_current_call" -> {
                 result.success(AgoraManager.instance.callViewModel.currentCall.value?.callPayload?.toMap())
                return
            }


            "join_ongoing_call" -> {
                try {

                    if(context == null){
                        result.success(false)
                        return
                    }

                    @Suppress("UNCHECKED_CAST")
                    val arguments = call.arguments as? Map<String?, Any?> ?: run {
                        result.success(false)
                        AppLogger.log("Method arguments null on join_ongoing_call native method")
                        return
                    }


                    val mappedArguments: Map<String?, Any?> = arguments
                        .filter { it.key != null && it.value != null }
                        .mapKeys { it.key as String }
                        .mapValues { it.value.toString() }

                    val callPayload = CallPayload.fromMap(mappedArguments)

                    val tempCallID = try {
                        UUID.fromString(callPayload.tempCallId)
                    } catch (e: Exception) {
                        result.success(false)
                        AppLogger.log("Exception while parsing uuid in join_ongoing_call native method ===> ${e.message}")
                        return
                    }

                    val myDetails = MyDetails.loadFromSharedPrefs(context = context!!) ?: run{
                        result.success(false)
                        AppLogger.log("My details null on join_ongoing_call native method")
                        return
                    }

                    val appCall = Call(uuid = tempCallID, callPayload = callPayload, isOutGoing = callPayload.callerId == myDetails.userId?.toInt(), wasJoiningOngoingCall = true)

                    // creating and configuring a connection
                    val connection = CallConnection(context = context!!.applicationContext, appCall)
                    connection.setCallerDisplayName(callPayload.receiverName ?: "Unknown", TelecomManager.PRESENTATION_ALLOWED)
                    connection.audioModeIsVoip = true
                    connection.connectionProperties = Connection.PROPERTY_SELF_MANAGED
                    connection.putExtras(callPayload.toBundle())

                    // storing current connection and call
                    CallConnection.currentConnection = connection

                    AgoraManager.instance.reportIncomingCall(context = context!!, call = appCall)

                    //
                    // starting or joining ongoing call
                    context!!.sendBroadcast(
                        CallBroadcastReceiver.buildBroadcastIntent(
                            context = context!!,
                            action = CallBroadcastActions.ACTION_CALL_ONGOING_JOIN,
                            data = callPayload.toBundle()
                        )
                    )

                    result.success(true)
                    return
                }
                catch (e:Exception){
                    AppLogger.log("Exception while joining ongoing call from a method channel ===> ${e.message}")
                    return result.success(false)
                }
            }

            else -> {
                 result.notImplemented()
                return
            }
        }
    }


}
