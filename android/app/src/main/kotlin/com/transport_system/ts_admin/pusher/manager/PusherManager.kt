package com.transport_system.ts_admin.pusher.manager

import android.content.Context
import com.pusher.client.Pusher
import com.pusher.client.PusherOptions
import com.pusher.client.connection.ConnectionState
import com.pusher.client.util.HttpChannelAuthorizer
import com.transport_system.ts_admin.data_providers.MyDetails
import com.transport_system.ts_admin.helpers.AppLogger

class PusherManager {


    private var pusher: Pusher? = null

    companion object {
        val instance = PusherManager()
    }

    fun initialize(context: Context) {
        try {
            if (isConnected()) {
                return
            }
            val myDetails = MyDetails.loadFromSharedPrefs(context = context)
            pusher = Pusher("HiXzy5MIniPeS24McIZ1VdIrZ", PusherOptions().apply {
                setHost(getHost(context = context))
                setWssPort(2096)
                setUseTLS(true)
                setChannelAuthorizer(HttpChannelAuthorizer(getAuthUrl(context = context)).apply {
                    setHeaders(
                        mapOf(
                            "Authorization" to "Bearer ${myDetails?.token}",
                            "Accept" to "application/json"
                        )
                    )
                })
            })
            pusher?.connect(PusherConnectionStateListener(pusherManager = this))
        } catch (e: Exception) {
            AppLogger.log("Exception while initializing the pusher ====> ${e.message}")
        }
    }

    fun getPusher(context: Context): Pusher? {
        if (pusher == null) {
            initialize(context = context)
        }
        return pusher
    }

    private fun isConnected(): Boolean {
        return pusher?.connection?.state == ConnectionState.CONNECTED
    }

    fun ensureConnection(context: Context) {
        try {
            if (!isConnected()) {
                if (pusher == null) {
                    initialize(context = context)
                    return
                }
                pusher?.connect()
            } else {
                AppLogger.log("Pusher socket is already connected.")
            }
        } catch (e: Exception) {
            AppLogger.log("Exception while ensure pusher socket connection called ===> ${e.message} ")
        }
    }

    private fun getHost(context: Context): String {
        return if (MyDetails.isProduction(context = context)) "socket.ts-portal.com" else "staging.ts-portal.com"
    }

    private fun getAuthUrl(context: Context): String {
        return "https://${
            if (MyDetails.isStaging(context = context)) "staging." else if (MyDetails.isDevelopment(
                    context = context
                )
            ) "dev." else ""
        }ts-portal.com/broadcasting/auth"
    }

}