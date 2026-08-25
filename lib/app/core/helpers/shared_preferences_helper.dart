// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';

/// if you update any thing in this file this may cause a issue in native codes and logics
class SharedPrefrencesHelper {
  /// please dont change these values this may ccause native values issues
  /// pref name = ''

  static const Token = "token";
  static const FirstName = "firstName";
  static const LastName = "lastName";
  static const UserId = "userId";
  static const ModelType = "modelType";
  static const Image = "image";
  static const ServerUrl = "serverUrl";
  static const IsStagingServer = "isStagingServer";
  static const AgoraAppId = "agoraAppId";
  static const RealtimeConfigVersion = "realtimeConfigVersion";

  // clock in/out perf names
  static const SessionId = "sessionId";
  static const SessionStartedAt = "sessionStartedAt";

  //
  static Future<void> storeMyDetails(UserEntity user, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Token, token);
    await prefs.setString(FirstName, user.firstName ?? "");
    await prefs.setString(LastName, user.lastName ?? "");
    await prefs.setInt(UserId, user.id ?? 0);
    await prefs.setString(ModelType, user.modelType ?? "");
    await prefs.setString(Image, user.image ?? "");
    await prefs.setString(ServerUrl, ApiConstants.kServerURL);
    await prefs.setBool(IsStagingServer, !ApiConstants.isProduction);
  }

  //
  static Future<void> clearMyDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Token);
    await prefs.remove(FirstName);
    await prefs.remove(LastName);
    await prefs.remove(UserId);
    await prefs.remove(ModelType);
    await prefs.remove(Image);
    await prefs.remove(ServerUrl);
    await prefs.remove(IsStagingServer);
  }

  static Future<void> storeRealtimeConfiguration(
      RealtimeConfiguration configuration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final agoraAppId = configuration.agora?.appId ?? "";
    if (agoraAppId.isNotEmpty) {
      await prefs.setString(AgoraAppId, agoraAppId);
    } else {
      await prefs.remove(AgoraAppId);
    }
    await prefs.setString(RealtimeConfigVersion, configuration.configVersion);
  }

  static Future<void> clearRealtimeConfiguration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AgoraAppId);
    await prefs.remove(RealtimeConfigVersion);
  }

  static Future<void> storeClockInOutSessionId(
      String sessionId, bool writeIfNull) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (writeIfNull) {
        final id = prefs.getString(SessionId);
        if (id == null) {
          await prefs.setString(SessionId, sessionId);
        }
      } else {
        await prefs.setString(SessionId, sessionId);
      }
      await prefs.setBool(IsStagingServer, !ApiConstants.isProduction);
      await prefs.setInt(
          SessionStartedAt, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  static Future<void> clearClockInOutSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SessionId);
    await prefs.remove(SessionStartedAt);
  }
}
