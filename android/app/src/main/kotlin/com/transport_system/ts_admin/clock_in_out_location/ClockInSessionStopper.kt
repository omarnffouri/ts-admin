package com.transport_system.ts_admin.clock_in_out_location



import android.app.Service
import android.content.Context
import com.transport_system.ts_admin.data_providers.MyDetails
import com.transport_system.ts_admin.network.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class ClockInSessionStopper {


    //
    fun clockOut(service : Service, context: Context){
        try {
            // clock in session and my details from shared prefs
            val session = ClockInOutSession.loadFromSharedPrefs(context)
            val myDetails = MyDetails.loadFromSharedPrefs(context)
            if(session != null && myDetails != null){

                if(session.sessionStartedAt == null){
                    return
                }

                val currentTimeMillis = System.currentTimeMillis()
                val differenceInMillis = currentTimeMillis - session.sessionStartedAt!!
                val differenceInMinutes = differenceInMillis / (1000 * 60)
                if(differenceInMinutes > 15){
                    return
                }

                // get client
                RetrofitClient.getClient(myDetails.serverUrl!!).clockInOut("Bearer ${myDetails.token!!}").enqueue(object : Callback<Void> {
                    override fun onResponse(call: Call<Void>, response: Response<Void>) {
                        service.stopSelf()
                    }

                    override fun onFailure(call: Call<Void>, t: Throwable) {

                    }
                })
            }
        }
        catch (_:Exception){
        }
    }





}