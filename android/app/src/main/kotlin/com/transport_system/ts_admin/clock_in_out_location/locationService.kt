package com.transport_system.ts_admin.clock_in_out_location

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager

import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.transport_system.ts_admin.activities.MainActivity


class LocationService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private var isUpdatingLocation = false
    companion object {
        const val CHANNEL_ID = "LocationServiceChannel"
        const val NOTIFICATION_ID = 125
    }


    @SuppressLint("MissingPermission")
    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        val locationRequest = LocationRequest.create().apply {
            interval = 20 * 60 * 1000 // 20 minutes
            fastestInterval = 15 * 60 * 1000 // 15 minutes
            priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
            smallestDisplacement = 50f
        }

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                super.onLocationResult(locationResult)
                for (location in locationResult.locations) {
                    val intent = Intent("LocationUpdate")
                    intent.putExtra("latitude", location.latitude.toDouble())
                    intent.putExtra("longitude", location.longitude.toDouble())
                    intent.putExtra("speed", location.speed.toDouble())
                    intent.putExtra("heading", location.bearing.toDouble())
                    LocalBroadcastManager.getInstance(this@LocationService).sendBroadcast(intent)
                    FirebaseLocationLogUpdater().updateLocationInFirebase(this@LocationService,location)
                }
            }


//            override fun onLocationAvailability(locationAvailability: LocationAvailability) {
//
//                if(!locationAvailability.isLocationAvailable){
//                    ClockInSessionStopper().clockOut(this@LocationService, context = applicationContext)
//                }
//
//            }
        }

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, null)


    }



    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (isUpdatingLocation) {
            println( "Location updates are already running.")
            return START_STICKY
        }

        // creating notification channels and showing ongoing notification
        createNotificationChannel()
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
//        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//        notificationManager.notify(NOTIFICATION_ID, createNotification())
        //
        //
        isUpdatingLocation = true


        return START_STICKY
    }

    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            CHANNEL_ID,
            "Location Service Channel",
            NotificationManager.IMPORTANCE_HIGH
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(serviceChannel)
    }

    private fun createNotification() : Notification {

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntentFlags =
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            pendingIntentFlags
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Navigator Active")
            .setContentText("Continuously updating your location for navigation.")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
    }



    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()

        fusedLocationClient.removeLocationUpdates(locationCallback)
        isUpdatingLocation = false
        // stop foreground service and remove the notification.
        stopForeground(STOP_FOREGROUND_REMOVE)
        // stop the background service.
        stopSelf()
    }
}
