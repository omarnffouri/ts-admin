package com.transport_system.ts_admin.activities

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.databinding.ActivityCallBinding
import com.transport_system.ts_admin.fragments.GroupAudioCallFragment
import com.transport_system.ts_admin.fragments.GroupVideoCallFragment
import com.transport_system.ts_admin.fragments.OtoAudioCallFragment
import com.transport_system.ts_admin.fragments.OtoVideoCallFragment
import com.transport_system.ts_admin.fragments.RingingFragment
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.telecom.models.CallPayload

class CallActivity : AppCompatActivity() {


    private lateinit var binding: ActivityCallBinding
    private val agoraManager = AgoraManager.instance
    val callViewModel = agoraManager.callViewModel

    companion object {

        private const val ACTION = "com.transport_system.ts_admin.ACTION_CALL_VIEW"
        private const val FROM_INCOMING_CALL_NOTIFICATION = "from_incoming_call_notification"
        private const val FROM_CALL_ACCEPT = "from_call_accept"
        private const val CALL_PAYLOAD = "call_payload"


        fun getIntent(data: Bundle, forIncomingCallNotification: Boolean, fromCallAccept: Boolean) =
            Intent(ACTION).apply {
                putExtra(CALL_PAYLOAD, data)
                putExtra(FROM_INCOMING_CALL_NOTIFICATION, forIncomingCallNotification)
                putExtra(FROM_CALL_ACCEPT, fromCallAccept)
                action = ACTION
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
    }


    @SuppressLint("CommitTransaction", "WrongConstant")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCallBinding.inflate(layoutInflater)
        setContentView(binding.root)


        try {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
            )
        }
        catch (_:Exception){}

        val callPayload: Bundle? = intent.getBundleExtra(CALL_PAYLOAD)
        if (callPayload == null) {
            finishThis()
            return
        }



        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            setTurnScreenOn(true)
        } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            @Suppress("DEPRECATION") window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
            @Suppress("DEPRECATION") window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
        }



        listenForCallUpdates()


        val fragment = if (intent.getBooleanExtra(FROM_INCOMING_CALL_NOTIFICATION, false)) {
            AppLogger.log("Replace and load call ringing fragment in on create")
            RingingFragment(callActivity = this)
        } else {
            if (callViewModel.currentCall.value?.callPayload?.callType == "video") {
                if (callViewModel.currentCall.value?.callPayload?.conversationType == "oto") {
                    AppLogger.log("Replace and load oto video call fragment in on create")
                    OtoVideoCallFragment(callActivity = this)
                } else {
                    AppLogger.log("Replace and load group video call fragment in on create")
                    GroupVideoCallFragment(callActivity = this)
                }
            } else {
                if (callViewModel.currentCall.value?.callPayload?.conversationType == "oto") {
                    AppLogger.log("Replace and load oto audio call fragment in on create")
                    OtoAudioCallFragment(callActivity = this)
                } else {
                    AppLogger.log("Replace and load group audio call fragment in on create")
                    GroupAudioCallFragment(callActivity = this)
                }
            }
        }

        supportFragmentManager.beginTransaction().replace(
            binding.fragmentContainerView.id, fragment
        ).commit()

    }


    @SuppressLint("MissingSuperCall", "CommitTransaction")
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        AppLogger.log("Activity tried to start again")

        if (intent.getBooleanExtra(FROM_CALL_ACCEPT, false)) {
            val callBundle = intent.getBundleExtra(CALL_PAYLOAD) ?: return
            val callPayload = CallPayload.fromBundle(callBundle)
            val callId = callPayload.tempCallId ?: return

            if (callId == callViewModel.currentCall.value?.uuid.toString()) {

                val fragment = if (callPayload.callType == "video") {
                    if (callPayload.conversationType == "oto") {
                        AppLogger.log("Replace and load oto video call fragment")
                        OtoVideoCallFragment(callActivity = this)
                    } else {
                        AppLogger.log("Replace and load group video call fragment")
                        GroupVideoCallFragment(callActivity = this)
                    }
                } else {
                    if (callPayload.conversationType == "oto") {
                        AppLogger.log("Replace and load oto audio call fragment")
                        OtoAudioCallFragment(callActivity = this)
                    } else {
                        AppLogger.log("Replace and load group audio call fragment")
                        GroupAudioCallFragment(callActivity = this)
                    }
                }

                supportFragmentManager.beginTransaction().replace(
                    binding.fragmentContainerView.id, fragment
                ).commit()


                if (!callViewModel.currentCall.hasActiveObservers()) {
                    AppLogger.log("Don't have any active listener for call updated, attaching listener")
                    listenForCallUpdates()
                }
            }

        }

    }


    private fun listenForCallUpdates() {
        callViewModel.currentCall.observe(this) { callPayload ->
            if (callPayload == null) {
                finishThis()
            }
        }
    }


    private fun finishThis() {
        if (!isFinishing) {
            finish()
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        callViewModel.currentCall.removeObservers(this)
    }

}