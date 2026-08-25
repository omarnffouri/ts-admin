import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';

class RealtimeConfigurationModel extends RealtimeConfiguration {
  const RealtimeConfigurationModel({
    required super.provider,
    required super.broadcaster,
    required super.appId,
    required super.key,
    required super.host,
    required super.port,
    required super.scheme,
    required super.path,
    required super.forceTls,
    required super.enabledTransports,
    required super.authEndpoint,
    required super.configVersion,
    super.agora,
  });

  factory RealtimeConfigurationModel.fromJson(Map<String, dynamic> json) {
    // The websocket settings are nested under `data.websocket`; only
    // `config_version` lives at the top level of `data`.
    final websocket = (json['websocket'] as Map<String, dynamic>?) ?? const {};
    final agora = json['agora'] as Map<String, dynamic>?;
    return RealtimeConfigurationModel(
      provider: websocket['provider'] as String,
      broadcaster: websocket['broadcaster'] as String,
      appId: websocket['app_id'] as String,
      key: websocket['key'] as String,
      host: websocket['host'] as String,
      port: (websocket['port'] as num).toInt(),
      scheme: websocket['scheme'] as String,
      path: websocket['path'] as String,
      forceTls: websocket['force_tls'] as bool,
      enabledTransports:
          List<String>.from(websocket['enabled_transports'] as List),
      authEndpoint: websocket['auth_endpoint'] as String,
      configVersion: json['config_version'] as String,
      agora: agora == null
          ? null
          : AgoraConfiguration(
              appId: agora['app_id'] as String?,
              appCertificate: agora['app_certificate'] as String?,
              appCustomerKey: agora['app_customer_key'] as String?,
              appCustomerSecret: agora['app_customer_secret'] as String?,
              notificationSecret: agora['notification_secret'] as String?,
            ),
    );
  }
}
