# Keep ThrowableExtension to prevent desugaring issues
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }

# Keep SLF4J Logger
-keep class org.slf4j.** { *; }
# Keep SLF4J classes to avoid R8 stripping them
-keep class org.slf4j.impl.** { *; }
-keep class org.slf4j.spi.** { *; }
-keep class org.slf4j.MDC { *; }
-keep class org.slf4j.MarkerFactory { *; }

# Keep Agora RTC SDK classes
-keep class io.agora.** { *; }
-keep class io.agora.rtc2.** { *; }

# Suppress warnings for the ThrowableExtension class (optional)
-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension

# Keep the Retrofit-related code (if using Retrofit)
-keep class retrofit2.** { *; }

# Keep Gson-related code (if using Gson for JSON parsing)
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }

# Preserve generic type information used by Gson
-keepattributes Signature


# Enable ProGuard for release builds by default
# R8 is the default shrinker and obfuscator in Android, which combines ProGuard and other optimizations
-keep class * extends java.lang.Exception { *; }
-keep class * extends java.lang.Error { *; }
-keep class java.util.List.** { *; }
-keep class java.lang.reflect.** { *; }
-keep class kotlin.collections.** { *; }
-keep class kotlin.jvm.** { *; }
-keep class kotlin.reflect.** { *; }

# Default setting to ensure that reflection works properly with libraries like Gson or Retrofit
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep app models
-keep class com.transport_system.ts_admin.data_providers.models.** { *; }
-keep class com.transport_system.ts_admin.agora.models.** { *; }
-keep class com.transport_system.ts_admin.network.models.** { *; }
-keep class com.transport_system.ts_admin.pusher.channels.call_channel.models.** { *; }
-keep class com.transport_system.ts_admin.telecom.models.** { *; }

# Keep DB decorder extension
-keep class com.transport_system.ts_admin.data_providers.database.extensions.DatabaseDecoderExtensionKt { *; }

-keep class androidx.lifecycle.DefaultLifecycleObserver { *; }

# Keep connection service class
-keep class android.telecom.Connection { *; }
