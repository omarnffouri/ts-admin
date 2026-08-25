//
//  AgoraManager.swift
//  Runner
//
//  Created by Hashim Khan on 11/12/2024.
//

import AgoraRtcKit
import Foundation
import AVFAudio
import AVFoundation
import SwiftUI

class AgoraManager : NSObject, ObservableObject  {

    static let shared = AgoraManager() // singleton instance


    var agoraEngine : AgoraRtcEngineKit?
    private var currentAppId : String?
    var myDetails = MyDetails.loadFromSharedPrefs()
    @Published var currentCall : Call?
    @Published var groupSettings : GroupSettingsModel?

    // Incoming accept defers its join here until CallScreenView resolves the
    // mic/camera permissions (it can host the prompt the locked CallKit UI can't).
    var pendingIncomingJoin = false


    // MARK:  Apis
    var callEndedEventApi : CallEndedEventApi = CallEndedEventApi()
    var startCallRecordingApi : StartCallRecordingApi = StartCallRecordingApi()
    var stopCallRecordingApi : StopCallRecordingApi = StopCallRecordingApi()


    // MARK:  Call State/Data Variables
    @Published var myPid : Int?
    @Published var participants : [ParticipantModel] = []
    @Published var callUsers : [CallUser] = []
    @Published var selectedCallUser : CallUser?
    @Published var localUserJoined : Bool = false
    @Published var remoteUserJoined : Bool = false
    @Published var audioMuted : Bool = false
    @Published var videoMuted : Bool = false
    @Published var speakerEnabled : Bool = false
    @Published var callRecording : StartCallRecordingModel?
    @Published var callState : CallState = .idle


    // MARK: Call Time Variables
    var callTimer: Timer?
    @Published var hours : Int = 0
    @Published var minutes : Int = 0
    @Published var seconds : Int = 0
    @Published var totalTicks : Int = 0


    override private init() {
        super.init()
        let appId = AgoraManager.desiredAppId()
        self.agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        self.currentAppId = appId
        applyCallKitAudioSessionRestriction()
    }

    // Prefer the server-synced agora app id (mirrored into prefs by Dart on
    // login and self-healed by RealtimeConfigApi.sync on the call path), else the
    // hardcoded per-env id so a call never blocks on a missing/failed config.
    private static func desiredAppId() -> String {
        return MyDetails.agoraAppId() ?? (MyDetails.isProduction() ? "b7bfc1ea224b4dc79d2a0fec4b45eb51" : "56ce6ab15eef486aa7b5b798c930042e")
    }

    // CallKit owns the AVAudioSession lifecycle. Restrict the SDK from
    // deactivating it (on leaveChannel / engine teardown / recreate) so that
    // destroying+rebuilding the engine while CallKit's session is active no
    // longer kills audio. Re-applied after every engine (re)creation.
    private func applyCallKitAudioSessionRestriction() {
        agoraEngine?.setAudioSessionOperationRestriction(.deactivateSession)
    }

    // Build the engine at ring time so it's alive when CallKit activates the
    // audio session on answer (cold-start no-audio fix).
    func prewarm() {
        if Thread.isMainThread {
            recreateEngineIfNeeded()
        } else {
            DispatchQueue.main.async { [weak self] in self?.recreateEngineIfNeeded() }
        }
    }

    // Re-bind Agora's audio I/O to the session CallKit just activated.
    func audioSessionDidActivate() {
        guard let engine = agoraEngine else { return }
        engine.enableAudio()
        engine.setEnableSpeakerphone(speakerEnabled)
        engine.muteLocalAudioStream(audioMuted)
    }

    // If the server rotated the agora app id (synced into prefs just before this
    // call), the existing engine still holds the old id and its token would
    // mismatch — rebuild it with the fresh id. Must run on the main thread.
    func recreateEngineIfNeeded() {
        let desired = AgoraManager.desiredAppId()
        if agoraEngine != nil && currentAppId == desired { return }
        AgoraRtcEngineKit.destroy()
        agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: desired, delegate: self)
        currentAppId = desired
        applyCallKitAudioSessionRestriction()
    }

    private func presentCallScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let rootView = CallScreenView()
                let hostingController = UIHostingController(rootView: rootView)
                hostingController.modalPresentationStyle = .fullScreen
                window.rootViewController?.present(hostingController, animated: true, completion: nil)
            }
        }
    }


    // MARK: - Join Channel
    private func joinChannel(withToken token: String? = nil, completion: @escaping (Bool) -> Void) {

        guard let channelName = currentCall?.callPayload.channelName, let myPid = myPid else {
            completion(false)
            return
        }
        guard let agoraEngine else {
            print("Cannot join Agora channel because the engine is not initialized.")
            completion(false)
            return
        }

        agoraEngine.setChannelProfile(.communication)
        agoraEngine.enableAudio()
        agoraEngine.setClientRole(.broadcaster)

        if(currentCall?.callPayload.callType == "video"){
            agoraEngine.enableVideo()
            agoraEngine.enableLocalVideo(true)
        }

        let result = agoraEngine.joinChannel(byToken: token, channelId: channelName, info: nil, uid: UInt(myPid)) { [weak self] (channel, uid, elapsed) in
            print("Joined channel \(channel) with UID \(uid)")

            if let strong = self {
                strong.localUserJoined = true
            }
            completion(true)
        }
        if result != 0 {
            completion(false)
        }
    }

    // MARK: - Leave Channel
    func leaveChannel(completion: @escaping (Bool) -> Void) {
        guard let agoraEngine else {
            localUserJoined = false
            completion(false)
            return
        }
        agoraEngine.leaveChannel { [weak self] _ in
            print("Left channel")
            if let strong = self {
                strong.localUserJoined = false
            }
            completion(true)
        }
    }



    // MARK: - Setup Local Video
    func setupLocalVideo(view: UIView) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        agoraEngine?.setupLocalVideo(videoCanvas)
    }

    // MARK: - Setup Remote Video
    func setupRemoteVideo(uid: UInt, view: UIView) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        videoCanvas.setupMode = .replace
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }

    func removeRemoteVideo(uid: UInt) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = nil
        videoCanvas.renderMode = .hidden
        videoCanvas.setupMode = .replace
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }



    func getAgoraToken(completion: @escaping (String?) -> Void){

        guard let channelName = currentCall?.callPayload.channelName, let pid = myPid else {
            completion(nil)
            return
        }

        Task{
            completion(await AgoraTokenApi.getAgoraToken(channelName: channelName , joiningAs: JoiningAs.attendee, pid: pid))
        }
    }

    // Refresh the realtime config (agora app id) before minting the token +
    // joining, so a rotated app id is applied and matches the signed token.
    // Best-effort: a failed sync degrades to the mirrored prefs / hardcoded
    // fallback instead of blocking the call. `onJoined` runs after the channel
    // is joined. The call screen is presented synchronously by the caller
    // (CallKit answer handler / placeCall / joinOngoingCall), not here, so the
    // window is foreground-active before Agora starts audio on a cold start.
    private func syncRecreateTokenThenJoin(
        callUuid: UUID,
        onJoined: @escaping () -> Void
    ) {
        Task { [weak self] in
            await RealtimeConfigApi.sync()
            await MainActor.run {
                guard let self else { return }
                self.recreateEngineIfNeeded()

                self.getAgoraToken() { [weak self] token in
                    DispatchQueue.main.async {
                        guard let self else { return }
                        guard let token else {
                            print("token is nil")
                            self.failedToLoadRequiredData(callUuid: callUuid)
                            return
                        }
                        print("token from the api ===> \(token)")
                        self.joinChannel(withToken: token) { success in
                            print("join channel success ===> \(success)")
                            if success {
                                onJoined()
                            } else {
                                self.failedToLoadRequiredData(callUuid: callUuid)
                            }
                        }
                    }
                }
            }
        }
    }



    // MARK: - Place call
    func placeCall(call : Call) {

        print("place call called from call kit in agora manager ===> \(call.uuid)")


        CallChannel.shared.printLog("Initializing the call channel on place call in agora manager")

        resetAgoraManager()
        self.currentCall = call
        callState = .calling


        //
        // loads and validates the call data before starting call
        guard loadCallData() else {
            print("Call params validation failed")
            failedToLoadRequiredData(callUuid: call.uuid)
            return
        }

        //
        // loading receiver image if call is outgoing
        if call.isOutGoing {
            self.currentCall?.callPayload.receiverImage = getOpositeUserImage()
        }
        //
        //notify call manager that call is now connecting
        CallManager.shared.reportOutgoingCallStatusToConnecting()

        // Present the call window synchronously before the media join (driver
        // parity) so the scene is foreground-active when Agora starts audio.
        presentCallScreen()

        syncRecreateTokenThenJoin(callUuid: call.uuid) { [weak self] in
            NativeCallingEventChannel.shared.sendEvent(event: .callPlaced, data: self?.currentCall?.callPayload.toDictionary() ?? [])
        }

    }


    // MARK: -  Call Accepted
    func callAccepted(call : Call) {



        print("call accepted called from call kit in agora manager ===> \(call.uuid)")

        CallChannel.shared.printLog("Initializing the call channel on call accepted in agora manager")

        resetAgoraManager()
        self.currentCall = call
        callState = .connecting

        //
        // loads and validates the call data before starting call
        guard loadCallData() else {
            print("Call params validation failed")
            failedToLoadRequiredData(callUuid: call.uuid)
            return
        }

        // Defer accepted-emit + join to CallScreenView: it shows a rationale
        // alert and hosts the permission prompt the locked CallKit UI can't.
        pendingIncomingJoin = true
        presentCallScreen()
    }

    // Join once permissions resolve; camera-denied video downgrades to audio.
    func joinAcceptedCall(cameraGranted: Bool) {
        guard let call = currentCall, pendingIncomingJoin else { return }
        pendingIncomingJoin = false

        if !cameraGranted && call.callPayload.callType == "video" {
            call.callPayload.callType = "audio"
            objectWillChange.send() // re-render CallScreenView to the audio layout
        }

        //
        // tell the caller + server the callee accepted BEFORE joining (mirrors
        // Android): the media join can fail/lag, but the caller must still learn
        // the call was answered instead of ringing on as 'no answer'.
        emitCallAcceptedEvents(call: call)

        callState = .connecting
        syncRecreateTokenThenJoin(callUuid: call.uuid) { [weak self] in
            self?.callState = .connected
        }
    }

    // Notify the Flutter layer + the caller (Pusher client-event) + the server
    // (accepted API) that the callee answered. Fired before the media join so a
    // slow/failed Agora join never leaves the caller ringing as 'no answer'.
    private func emitCallAcceptedEvents(call: Call) {
        NativeCallingEventChannel.shared.sendEvent(event: .callReceived, data: call.callPayload.toDictionary())

        CallChannel.shared.getCallChannel()?.trigger(eventName: "client-call-accepted", data: [
            "calledBy": [
                "userId":  call.callPayload.callerId as Any,
                "userModelType":  call.callPayload.callerModelType as Any,
                "userName":  call.callPayload.callerName as Any,
                "userImage":  call.callPayload.callerImage as Any,
            ],
            "conversationId" : call.callPayload.conversationId as Any,
            "isOnCall": "mobile",
        ])

        CallEventHelper.callAccepted(payload: call.callPayload)
    }


    // MARK: - Join ongoing call
    func joinOngoingCall(call : Call) {

        print("join ongoing call called from call kit in agora manager ===> \(call.uuid)")


        CallChannel.shared.printLog("Initializing the call channel on joing ongoing call in agora manager")

        resetAgoraManager()
        self.currentCall = call
        callState = .connecting


        //
        // loads and validates the call data before starting call
        guard loadCallData() else {
            print("Call params validation failed")
            failedToLoadRequiredData(callUuid: call.uuid)
            return
        }

        //
        // loading receiver image if call is outgoing
        if call.isOutGoing {
            self.currentCall?.callPayload.receiverImage = getOpositeUserImage()
        }
        //
        //notify call manager that call is now connecting
        CallManager.shared.reportOutgoingCallStatusToConnecting()

        // Verify the permissions this call type needs (mic always, camera only
        // for video) before announcing acceptance or joining.
        ensureCallPermissions(isVideo: call.callPayload.callType == "video") { [weak self] granted in
            guard let self else { return }
            guard granted else {
                print("Required call permissions not granted while joining the ongoing call")
                self.failedToLoadRequiredData(callUuid: call.uuid)
                return
            }

            //
            // tell the caller + server we joined the ongoing call BEFORE the media
            // join, mirroring the accept path.
            self.emitCallAcceptedEvents(call: call)

            // Present the call window synchronously before the media join (driver
            // parity) so the scene is foreground-active when Agora starts audio.
            self.presentCallScreen()

            self.syncRecreateTokenThenJoin(callUuid: call.uuid) { [weak self] in
                self?.callState = .connected
            }
        }

    }




    // MARK: - End Call
    func endCall() {
        print("end call called in agora manager")

        stopCallTimer()
        if let payload = currentCall?.callPayload, remoteUserJoined , totalTicks > 0 {
            Task{
                await callEndedEventApi.callEnded(payload: payload, callSeconds: totalTicks)
            }
        }
        leaveChannel(){ _ in
        }
        CallManager.shared.endCall(callUuid: self.currentCall?.uuid)
        NativeCallingEventChannel.shared.sendEvent(event: .callEnded, data: currentCall?.callPayload.toDictionary() ?? [])
        resetAgoraManager()
    }





    // MARK: - Permissions

    // Gate a call on the permissions it actually needs: microphone is required
    // for every call, the camera only for video calls. Mirrors the Dart
    // outgoing-call check (hasEnoughPermissions) so an incoming audio call never
    // asks for camera access. Used on the join-ongoing path; the incoming-accept
    // path gates in CallScreenView (rationale alert) via joinAcceptedCall.
    func ensureCallPermissions(isVideo: Bool, completion: @escaping (Bool) -> Void) {
        requestMicPermission { [weak self] micGranted in
            guard micGranted else {
                completion(false)
                return
            }
            guard isVideo else {
                completion(true)
                return
            }
            self?.requestCameraPermission { cameraGranted in
                completion(cameraGranted)
            }
        }
    }

    private func requestMicPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        @unknown default:
            completion(false)
        }
    }

    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        @unknown default:
            completion(false)
        }
    }

    // MARK: - Failure Functions


    //
    // function to handle a failure while loading data after accepting the call
    // might be any data null or failed to load
    func failedToLoadRequiredData(callUuid : UUID?) {
        callState = .failed
        NativeCallingEventChannel.shared.sendEvent(event: .callFailed, data: currentCall?.callPayload.toDictionary() ?? [])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            CallManager.shared.failedToJoinCall(callUuid: callUuid)
            self.resetAgoraManager()
        })
    }
}
