package com.transport_system.ts_admin.activities

import android.Manifest
import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.transport_system.ts_admin.clock_in_out_location.LocationService
import com.transport_system.ts_admin.native_calling_plugin.NativeCallingPlugin
import com.transport_system.ts_admin.notification_managers.AppNotificationChannelManager
import com.transport_system.ts_admin.pusher.manager.PusherManager
import com.transport_system.ts_admin.pusher.channels.call_channel.channel.CallChannel
import com.transport_system.ts_admin.pusher.channels.call_channel.events.CallAcceptedEvent
import com.transport_system.ts_admin.pusher.channels.call_channel.events.CallDeclinedEvent
import com.transport_system.ts_admin.pusher.channels.call_channel.events.CallNoAnswerEvent
import com.transport_system.ts_admin.pusher.channels.call_channel.events.CallRingingEvent
import com.transport_system.ts_admin.pusher.channels.call_channel.events.CallUserBusyEvent
import com.transport_system.ts_admin.telecom.managers.PhoneAccountManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "tracking_service"
    private lateinit var methodChannel: MethodChannel
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationUpdateReceiver: BroadcastReceiver
    private val MY_PERMISSIONS_REQUEST_LOCATION = 99



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.plugins.add(NativeCallingPlugin())

        // registering phone account
        PhoneAccountManager.registerPhoneAccount(context = applicationContext)

        // initializing pusher and call channel and events
        PusherManager.instance.initialize(context = applicationContext)
        CallChannel.instance.initialize(context = applicationContext)
        CallAcceptedEvent.initialize(context = applicationContext).bind()
        CallDeclinedEvent.initialize(context = applicationContext).bind()
        CallNoAnswerEvent.initialize(context = applicationContext).bind()
        CallRingingEvent.initialize(context = applicationContext).bind()
        CallUserBusyEvent.initialize(context = applicationContext).bind()

        // ensure call notification channels
        AppNotificationChannelManager().ensureAllChannels(context = applicationContext)


        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationUpdates" -> {
                    if (checkLocationPermission()) {
                        startLocationUpdates()
                        result.success(null)
                    } else {
                        result.error("PERMISSION_DENIED", "Location permission denied", null)
                    }
                }

                "isLocationServiceRunning" -> {
                    try {
                        result.success(isLocationServiceRunning())
                    } catch (e: Exception) {
                        result.error(
                            "UNKNOWN_ERROR",
                            "Unable to check isLocationServiceRunning",
                            null
                        )
                    }
                }

                "stopLocationUpdates" -> {
                    stopLocationUpdates()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // Initialize BroadcastReceiver
        locationUpdateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                // print the intent extras
                println(intent.extras)
                val latitude = intent.getDoubleExtra("latitude", 0.0).toDouble();
                val longitude = intent.getDoubleExtra("longitude", 0.0).toDouble();
                val speed = intent.getDoubleExtra("speed", 0.0).toDouble();
                val heading = intent.getDoubleExtra("heading", 0.0).toDouble();
                methodChannel.invokeMethod(
                    "onLocationUpdate",
                    mapOf(
                        "latitude" to latitude,
                        "longitude" to longitude,
                        "speed" to speed,
                        "heading" to heading
                    )
                )
            }
        }

        // Register the BroadcastReceiver
        LocalBroadcastManager.getInstance(this)
            .registerReceiver(locationUpdateReceiver, IntentFilter("LocationUpdate"))
    }


    // checkLocationPermission() checks if the app has permission to access the device's location.
    private fun checkLocationPermission(): Boolean {
        return (ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED)
    }

    // onRequestPermissionsResult() is called when the user responds to the permission request dialog.
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            MY_PERMISSIONS_REQUEST_LOCATION -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    if (ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.ACCESS_FINE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        startLocationUpdates()
                    }
                }
            }
        }
    }

    // startLocationUpdates() starts the location service.
    private fun startLocationUpdates() {
        if (isLocationServiceRunning()) {
            return
        }
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // Request runtime permissions
            return
        }

        Intent(this, LocationService::class.java).also { intent ->
            startService(intent)
        }
    }

    private fun isLocationServiceRunning(): Boolean {
        val manager = baseContext.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningProcesses = manager.runningAppProcesses
        if (runningProcesses != null) {
            for (processInfo in runningProcesses) {
                if (processInfo.processName == baseContext.packageName && processInfo.importance != ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                    return true
                }
            }
        }
        return false
    }


    fun isServiceRunning(context: Context, serviceClass: Class<*>): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }

    private fun stopLocationUpdates() {
        Intent(this, LocationService::class.java).also { intent ->
            stopService(intent)
        }
        println("Stopping location updates")
    }

    override fun onDestroy() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(locationUpdateReceiver)
        super.onDestroy()
    }
}
