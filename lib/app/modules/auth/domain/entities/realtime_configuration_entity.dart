import 'package:equatable/equatable.dart';

class RealtimeConfiguration extends Equatable {
  final String provider;
  final String broadcaster;
  final String appId;
  final String key;
  final String host;
  final int port;
  final String scheme;
  final String path;
  final bool forceTls;
  final List<String> enabledTransports;
  final String authEndpoint;
  final String configVersion;
  final AgoraConfiguration? agora;

  const RealtimeConfiguration({
    required this.provider,
    required this.broadcaster,
    required this.appId,
    required this.key,
    required this.host,
    required this.port,
    required this.scheme,
    required this.path,
    required this.forceTls,
    required this.enabledTransports,
    required this.authEndpoint,
    required this.configVersion,
    this.agora,
  });

  /// Mirrors the API/storage shape: the socket settings live under
  /// `websocket`, Agora under `agora`, and `config_version` at the top level.
  /// Keep this symmetric with [RealtimeConfigurationModel.fromJson] — the value
  /// is round-tripped through GetStorage.
  Map<String, dynamic> toJson() {
    return {
      'websocket': {
        'provider': provider,
        'broadcaster': broadcaster,
        'app_id': appId,
        'key': key,
        'host': host,
        'port': port,
        'scheme': scheme,
        'path': path,
        'force_tls': forceTls,
        'enabled_transports': enabledTransports,
        'auth_endpoint': authEndpoint,
      },
      'agora': agora?.toJson(),
      'config_version': configVersion,
    };
  }

  @override
  List<Object?> get props => [
        provider,
        broadcaster,
        appId,
        key,
        host,
        port,
        scheme,
        path,
        forceTls,
        enabledTransports,
        authEndpoint,
        configVersion,
        agora,
      ];
}

/// Agora (voice/video) credentials returned alongside the websocket config.
/// All fields are nullable so a partial/absent block never crashes parsing.
class AgoraConfiguration extends Equatable {
  final String? appId;
  final String? appCertificate;
  final String? appCustomerKey;
  final String? appCustomerSecret;
  final String? notificationSecret;

  const AgoraConfiguration({
    this.appId,
    this.appCertificate,
    this.appCustomerKey,
    this.appCustomerSecret,
    this.notificationSecret,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'app_certificate': appCertificate,
      'app_customer_key': appCustomerKey,
      'app_customer_secret': appCustomerSecret,
      'notification_secret': notificationSecret,
    };
  }

  @override
  List<Object?> get props => [
        appId,
        appCertificate,
        appCustomerKey,
        appCustomerSecret,
        notificationSecret,
      ];
}
