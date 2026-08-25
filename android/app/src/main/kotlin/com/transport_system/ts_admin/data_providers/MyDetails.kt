package com.transport_system.ts_admin.data_providers

import android.content.Context


class MyDetails  {
    companion object{
        private const val Token : String = "flutter.token"
        private const val FirstName  : String = "flutter.firstName"
        private const val LastName  : String = "flutter.lastName"
        private const val UserId  : String = "flutter.userId"
        private const val ModelType  : String = "flutter.modelType"
        private const val Image  : String = "flutter.image"
        private const val ServerUrl : String = "flutter.serverUrl"

        // realtime/agora config mirrored from the server's realtime-configuration
        // by Dart (SharedPrefrencesHelper.storeRealtimeConfiguration) and
        // self-healed by the native call path (RealtimeConfigApi.sync). Keys must
        // match what Dart writes.
        private const val AgoraAppId : String = "flutter.agoraAppId"
        private const val RealtimeConfigVersion : String = "flutter.realtimeConfigVersion"

        // Agora app id mirrored from the server's realtime-configuration; null
        // when blank so callers can fall back to the hardcoded per-env id.
        fun agoraAppId(context: Context): String? =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                .getString(AgoraAppId, null)?.takeIf { it.isNotEmpty() }

        fun realtimeConfigVersion(context: Context): String? =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                .getString(RealtimeConfigVersion, null)?.takeIf { it.isNotEmpty() }

        // Persist a freshly-fetched realtime config into the same Flutter prefs
        // Dart mirrors into, so a cold-start call can self-heal a rotated agora
        // app id without Dart running. Keys match SharedPrefrencesHelper exactly.
        fun storeRealtimeConfig(
            context: Context,
            agoraAppId: String?,
            configVersion: String?,
        ) {
            val editor = context
                .getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                .edit()
            if (!agoraAppId.isNullOrEmpty()) editor.putString(AgoraAppId, agoraAppId)
            if (!configVersion.isNullOrEmpty()) editor.putString(RealtimeConfigVersion, configVersion)
            editor.apply()
        }



        fun loadFromSharedPrefs(context : Context) : MyDetails?{
            try {
                val sharedPrefs = context.getSharedPreferences("FlutterSharedPreferences",Context.MODE_PRIVATE)
                val token = sharedPrefs.getString(Token ,"")
                val firstName = sharedPrefs.getString(FirstName ,"")
                val lastName = sharedPrefs.getString(LastName ,"")
                val userId = sharedPrefs.getLong(UserId ,0)
                val modelType = sharedPrefs.getString(ModelType,"")
                val image = sharedPrefs.getString(Image,"")
                val serverUrl = sharedPrefs.getString(ServerUrl,"")
                return if(token.isNullOrEmpty() || (userId <= 0) || serverUrl.isNullOrEmpty()){
                    null
                } else{
                    val obj = MyDetails()
                    obj.token = token
                    obj.firstName = firstName
                    obj.lastName = lastName
                    obj.userId = userId
                    obj.modelType = modelType
                    obj.image = image
                    obj.serverUrl = serverUrl
                    obj
                }
            }
            catch (_:Exception){
                return  null
            }
        }



        fun isProduction(context: Context): Boolean{
            return ((!isStaging(context = context)) && (!isDevelopment(context = context)))
        }


        fun isStaging(context: Context) : Boolean{
            val serverUrl = loadFromSharedPrefs(context = context)?.serverUrl ?: return true
            return serverUrl.contains("staging")
        }

        fun isDevelopment(context: Context) : Boolean {
            val serverUrl = loadFromSharedPrefs(context = context)?.serverUrl ?: return true
            return serverUrl.contains("dev")
        }
    }


    var token: String? = null
    var firstName: String? = null
    var lastName: String? = null
    var modelType: String? = null
    var image: String? = null
    var serverUrl: String? = null
    var userId: Long? = null




}

