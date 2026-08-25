package com.transport_system.ts_admin.telecom.managers

import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager
import androidx.core.content.ContextCompat
import com.transport_system.ts_admin.R
import com.transport_system.ts_admin.telecom.service.ConnectionService


object PhoneAccountManager {

    private const val PHONE_ACCOUNT_HANDLER_ID = "e6cf8f24-1c7f-42a2-8a22-8c8bc4a3432e"

    fun registerPhoneAccount(context: Context) {

        // check if already registered then no need to register again
        if (isPhoneAccountRegistered(context = context)) {
            return
        }

        // phone account handler
        val phoneAccountHandle = getPhoneAccountHandler(context = context)

        // creating and configuring phone account
        val phoneAccount = PhoneAccount.builder(phoneAccountHandle, "TS Admin")
            .setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED)
            .setHighlightColor(
                ContextCompat.getColor(
                    context,
                    R.color.colorPrimary
                )
            ) // Optional UI color
            .setShortDescription("TS Admin VoIP Service")
            .build()

        // registering phone account
        getTelecomManager(context = context).registerPhoneAccount(phoneAccount)
    }

     fun getTelecomManager(context: Context): TelecomManager {
        return context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
    }

    private fun isPhoneAccountRegistered(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val telecomManager = getTelecomManager(context)
            val selfManagedPhoneAccounts = telecomManager.getOwnSelfManagedPhoneAccounts()
            return selfManagedPhoneAccounts.any { it.id == PHONE_ACCOUNT_HANDLER_ID }
        } else {
            return false
        }
    }

     fun getPhoneAccountHandler(context: Context): PhoneAccountHandle {
        val componentName = ComponentName(context, ConnectionService::class.java)
        return PhoneAccountHandle(componentName, PHONE_ACCOUNT_HANDLER_ID)
    }

}