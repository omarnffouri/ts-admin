package com.transport_system.ts_admin.agora.apis

import android.content.Context
import com.transport_system.ts_admin.data_providers.MyDetails
import com.transport_system.ts_admin.helpers.AppLogger
import com.transport_system.ts_admin.network.RetrofitClient
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object AgoraTokenApi {


    fun getAgoraToken(context: Context, role: String, channelName:String, pid : Int, onSuccess : (String?) -> Unit){
        try {
            val myDetails = MyDetails.loadFromSharedPrefs(context)
            if (myDetails == null){
                onSuccess(null)
                return
            }

            RetrofitClient.getClient(myDetails.serverUrl!!).getAgoraToken("Bearer ${myDetails.token!!}", role = role, channelName = channelName, pid = pid).enqueue(object :
                Callback<String> {
                override fun onResponse(call: Call<String>, response: Response<String>) {
                    onSuccess(response.body())
                }

                override fun onFailure(call: Call<String>, t: Throwable) {
                    onSuccess(null)
                }
            })
        }
        catch (e:Exception){
            AppLogger.log("Exception while getting agora token (try-catch) ===> ${e.message}")
            onSuccess(null)
        }
    }

}