package com.transport_system.ts_admin.fragments

import android.graphics.PorterDuff
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import com.squareup.picasso.Picasso
import com.transport_system.ts_admin.R
import com.transport_system.ts_admin.activities.CallActivity
import com.transport_system.ts_admin.agora.AgoraManager
import com.transport_system.ts_admin.agora.enums.CallState
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastActions
import com.transport_system.ts_admin.broadcast_receiver.CallBroadcastReceiver
import com.transport_system.ts_admin.databinding.FragmentOtoAudioCallBinding
import com.transport_system.ts_admin.helpers.AppLogger


class OtoAudioCallFragment(private val callActivity: CallActivity) : Fragment() {

    private lateinit var binding: FragmentOtoAudioCallBinding
    private val agoraManager = AgoraManager.instance
    private val callViewModel = agoraManager.callViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentOtoAudioCallBinding.inflate(inflater, container, false)
        loadData()
        attachObservers()
        return binding.root
    }


    private fun loadData() {

        binding.callControlView.btnMuteVideo.visibility = View.GONE
        binding.callControlView.btnSwitchCamera.visibility = View.GONE

        binding.callControlView.btnEndCall.setOnClickListener {
            val callPayload = callViewModel.currentCall.value?.callPayload ?: return@setOnClickListener
            callActivity.sendBroadcast(
                CallBroadcastReceiver.buildBroadcastIntent(
                    context = callActivity.applicationContext,
                    action = CallBroadcastActions.ACTION_CALL_ENDED,
                    data = callPayload.toBundle()
                )
            )
        }

        binding.backButton.setOnClickListener {
            if (!callActivity.isFinishing) {
                callActivity.finish()
            }
        }

        binding.callControlView.btnMuteAudio.setOnClickListener {
            agoraManager.toggleAudioMute()
        }

        binding.callControlView.btnSpeaker.setOnClickListener {
            agoraManager.toggleSpeakerEnable()
        }

        binding.userName.text = callViewModel.getOppositeUser()?.name
        binding.callTime.text = callViewModel.callState.value?.getName()
        try{
            Picasso.get()
                .load(callViewModel.getOppositeUser()?.image)
                .into(binding.callerImage)
        }
        catch (_:Exception){}


    }

    private fun attachObservers() {
        listenForCallControlUpdates()
        listenForCallState()
        listenForCallTime()
    }

    private fun listenForCallControlUpdates() {
        AppLogger.log("Attaching call control observers in oto audio call fragment")
        // listening audio mute state and updating button icon and style
        callViewModel.audioMuted.observe(viewLifecycleOwner) { muted ->
            AppLogger.log("Audio mute observer called in oto audio call fragment ===> mute : $muted")
            binding.callControlView.btnMuteAudio.setBackgroundResource(if (muted) R.drawable.circle_white_background else R.drawable.circle_gray_background)
            binding.callControlView.btnMuteAudio.setImageResource(if (muted) R.drawable.mic_off else R.drawable.mic_on)
            binding.callControlView.btnMuteAudio.setColorFilter(
                ContextCompat.getColor(
                    callActivity,
                    if (muted) R.color.colorPrimary else R.color.white
                ), PorterDuff.Mode.SRC_IN
            )
        }

        // listening speaker state and updating button icon and style
        callViewModel.speakerEnabled.observe(viewLifecycleOwner) { enabled ->
            AppLogger.log("Speaker observer called in oto audio call fragment ===> enabled : $enabled")
            binding.callControlView.btnSpeaker.setBackgroundResource(if (enabled) R.drawable.circle_white_background else R.drawable.circle_gray_background)
            binding.callControlView.btnSpeaker.setImageResource(if (!enabled) R.drawable.speaker_off else R.drawable.speaker_on)
            binding.callControlView.btnSpeaker.setColorFilter(
                ContextCompat.getColor(
                    callActivity,
                    if (enabled) R.color.colorPrimary else R.color.white
                ), PorterDuff.Mode.SRC_IN
            )
        }
    }

    private fun listenForCallState(){
        callViewModel.callState.observe(viewLifecycleOwner) { state ->
            binding.callTime.text = state.getName()
        }
    }

    private fun listenForCallTime() {
        callViewModel.hours.observe(viewLifecycleOwner) {
            updateCallTime()
        }
        callViewModel.minutes.observe(viewLifecycleOwner) {
            updateCallTime()
        }
        callViewModel.seconds.observe(viewLifecycleOwner) {
            updateCallTime()
        }
    }

    private fun updateCallTime() {

        val hours = callViewModel.hours.value ?: 0
        val minutes = callViewModel.minutes.value ?: 0
        val seconds = callViewModel.seconds.value ?: 0

        if (callViewModel.callState.value != CallState.CONNECTED && hours <= 0 && minutes <= 0 && seconds <= 0){
            return
        }

        // building time string
        var timeString = ""

        if(hours > 0){
            if (hours < 10){
                timeString += "0"
            }
            timeString += "$hours : "
        }

        if (minutes < 10){
            timeString += "0"
        }
        timeString += "$minutes : "

        if (seconds < 10){
            timeString += "0"
        }
        timeString += seconds.toString()

        binding.callTime.text = timeString
    }

    override fun onDestroyView() {
        callViewModel.audioMuted.removeObservers(viewLifecycleOwner)
        callViewModel.speakerEnabled.removeObservers(viewLifecycleOwner)
        callViewModel.hours.removeObservers(viewLifecycleOwner)
        callViewModel.minutes.removeObservers(viewLifecycleOwner)
        callViewModel.seconds.removeObservers(viewLifecycleOwner)
        callViewModel.callState.removeObservers(viewLifecycleOwner)
        super.onDestroyView()
    }

}