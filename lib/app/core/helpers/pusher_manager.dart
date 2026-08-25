// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/controllers/auth_controller.dart';
import 'package:ts_admin/app/core/helpers/realtime_configuration_storage_helper.dart';
import 'package:ts_admin/app/core/network/connection/api_constants.dart';
import 'package:ts_admin/app/core/values/authentication_preferences_keys.dart';
import 'package:ts_admin/app/core/values/user_preferences_keys.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';

class PusherManager {
  String userId = GetStorage().read(UserPrefKeys.userId).toString();

  PusherChannelsClient? client;
  PublicChannel? _activeCountChannel;
  PresenceChannel? _onlineChannel;
  PrivateChannel? _messageNotificationChannel;
  PrivateChannel? _messageDataChannel;
  PrivateChannel? _callEventChannel;
  PusherChannelsClientLifeCycleState? connectionState;

  Future<void> initializePusher() async {
    userId = GetStorage().read(UserPrefKeys.userId).toString();
    final configuration = _configuration;
    final clusterOptions = PusherChannelsOptions.custom(
      uriResolver: (metadata) {
        return _buildSocketUri(configuration);
      },
    );

    debugPrint('Pusher config: ${clusterOptions.uri} | user: $userId');

    // creating client
    client = PusherChannelsClient.websocket(
      options: clusterOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        debugPrint(
            "/////////////////////////////////////////////////// Connection Error //////////////////////////////////////////////////////");
        debugPrint(exception.toString());
        debugPrint(trace.toString());
        refresh();
      },
      minimumReconnectDelayDuration: const Duration(seconds: 1),
      defaultActivityDuration: const Duration(seconds: 5),
      activityDurationOverride: const Duration(seconds: 5),
      waitForPongDuration: const Duration(seconds: 10),
    );

    // attaching connection state listener
    client!.onConnectionEstablished.listen((_) {
      debugPrint("Connection Established");
    });

    client!.lifecycleStream.listen((state) {
      connectionState = state;
    });

    await client!.connect();
  }

  RealtimeConfiguration get _configuration {
    final configuration = RealtimeConfigurationStorageHelper.read();
    if (configuration == null) {
      throw StateError('Realtime configuration is missing from storage.');
    }
    return configuration;
  }

  Uri _buildSocketUri(RealtimeConfiguration configuration) {
    final socketScheme = _socketScheme(configuration);
    final path = configuration.path.startsWith('/')
        ? configuration.path
        : '/${configuration.path}';
    return Uri.parse(
      '$socketScheme://${configuration.host}:${configuration.port}$path/${configuration.key}',
    );
  }

  String _socketScheme(RealtimeConfiguration configuration) {
    if (configuration.scheme == 'ws' || configuration.scheme == 'wss') {
      return configuration.scheme;
    }
    if (configuration.scheme == 'https' && configuration.forceTls) {
      return 'wss';
    }
    if (configuration.scheme == 'http' && !configuration.forceTls) {
      return 'ws';
    }
    throw StateError(
      'Unsupported realtime scheme ${configuration.scheme} with force_tls ${configuration.forceTls}.',
    );
  }

  ensureConnection() async {
    try {
      if (connectionState !=
          PusherChannelsClientLifeCycleState.establishedConnection) {
        await client!.disconnect();
        await client!.connect();
        if (_activeCountChannel != null) {
          _activeCountChannel!.subscribe();
        }
        if (_onlineChannel != null) {
          _onlineChannel!.subscribe();
        }
        if (_messageNotificationChannel != null) {
          _messageNotificationChannel!.subscribe();
        }
        if (_messageDataChannel != null) {
          _messageDataChannel!.subscribe();
        }
        if (_callEventChannel != null) {
          _callEventChannel!.subscribe();
        }
      }
    } catch (_) {}
  }

  Future<PrivateChannel> subscribeToMessageNotificationChannel() async {
    try {
      await ensureConnection();
      final bearerToken = GetStorage().read(AuthenticationPrefKeys.token);
      _messageNotificationChannel =
          _createMessageNotificationChannel(bearerToken, userId);
      _messageNotificationChannel!.subscribe();
      notifyPrivateEventStatus(_messageNotificationChannel!);
    } catch (_) {}
    return _messageNotificationChannel!;
  }

  Future<PrivateChannel> subscribeToMessageDataChannel(
      String conversationId) async {
    try {
      await ensureConnection();
      final bearerToken = GetStorage().read(AuthenticationPrefKeys.token);

      _messageDataChannel =
          _createMessageDataChannel(bearerToken, conversationId);
      _messageDataChannel!.subscribe();
      notifyPrivateEventStatus(_messageDataChannel!);
    } catch (_) {}
    return _messageDataChannel!;
  }

  Future<PrivateChannel> subscribeToCallEventChannel() async {
    try {
      await ensureConnection();
      final bearerToken = GetStorage().read(AuthenticationPrefKeys.token);
      if (_callEventChannel != null) {
        if (_callEventChannel!.state?.status != ChannelStatus.subscribed) {
          _callEventChannel!.subscribe();
        }
        return _callEventChannel!;
      }
      _callEventChannel = _createCallEventChannel(bearerToken);
      _callEventChannel!.subscribe();
      notifyPrivateEventStatus(_callEventChannel!);
    } catch (_) {}
    return _callEventChannel!;
  }

  Future<PublicChannel> subscribeToActiveCountChannel() async {
    try {
      await ensureConnection();
      _activeCountChannel = _createActiveCountChannel();
      _activeCountChannel!.subscribe();
      notifyPublicEventStatus(_activeCountChannel!);
    } catch (_) {}
    return _activeCountChannel!;
  }

  Future<PresenceChannel> subscribeToOnlineChannel() async {
    try {
      await ensureConnection();
      final bearerToken = GetStorage().read(AuthenticationPrefKeys.token);
      _onlineChannel = _createOnlineChannel(bearerToken, userId);
      _onlineChannel!.subscribe();
      notifyPersenceEventStatus(_onlineChannel!);
    } catch (_) {}
    return _onlineChannel!;
  }

  /////////////////// Unsubscribers
  void unsubscribeMessageNotificationChannel() {
    try {
      if (_messageNotificationChannel != null) {
        _messageNotificationChannel?.unsubscribe();
      }
      _messageNotificationChannel = null;
    } catch (_) {}
  }

  void unsubscribeMessageDataChannel() {
    try {
      if (_messageDataChannel != null) {
        _messageDataChannel?.unsubscribe();
      }
      _messageDataChannel = null;
    } catch (_) {}
  }

  void unsubscribeActiveCountChannel() {
    try {
      if (_activeCountChannel != null) {
        _activeCountChannel?.unsubscribe();
      }
      _activeCountChannel = null;
    } catch (_) {}
  }

  void unsubscribeOnlineChannel() {
    try {
      if (_onlineChannel != null) {
        _onlineChannel?.unsubscribe();
      }
      _onlineChannel = null;
    } catch (_) {}
  }

  /////////////////// private source creation functions

  Map<String, String> _authHeaders(String token) => {
        ApiConstants.authorizationHeader: ApiConstants.bearer(token),
        ApiConstants.acceptHeader: ApiConstants.jsonContentType,
      };

  PrivateChannel _createMessageNotificationChannel(
      String token, String userId) {
    return client!.privateChannel(
      'private-conversation-receiver-users-$userId',
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: Uri.parse(_configuration.authEndpoint),
        headers: _authHeaders(token),
      ),
    );
  }

  PrivateChannel _createMessageDataChannel(
      String token, String conversationId) {
    return client!.privateChannel(
      'private-conversation-$conversationId',
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: Uri.parse(_configuration.authEndpoint),
        headers: _authHeaders(token),
      ),
    );
  }

  PrivateChannel _createCallEventChannel(String token) {
    //
    final authController = Get.find<AuthController>();
    //
    //
    return client!.privateChannel(
      'private-call-receiver-${authController.user.value?.modelType}-${authController.user.value?.id}',
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: Uri.parse(_configuration.authEndpoint),
        headers: _authHeaders(token),
      ),
    );
  }

  PublicChannel _createActiveCountChannel() {
    return client!.publicChannel("active-count");
  }

  PresenceChannel _createOnlineChannel(String token, String userId) {
    return client!.presenceChannel(
      "presence-online-channel",
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPresenceChannel(
        authorizationEndpoint: Uri.parse(_configuration.authEndpoint),
        headers: _authHeaders(token),
      ),
    );
  }

  //////////////////// public and private event status notifier functions

  void notifyPublicEventStatus(PublicChannel publicChannel) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint(
          '${publicChannel.name} channel subscription status ===> ${publicChannel.state?.status.name}');
      if (publicChannel.state?.status.name == "subscribed" || timer.tick == 5) {
        timer.cancel();
      }
    });
  }

  void notifyPersenceEventStatus(PresenceChannel presenceChannel) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint(
          '${presenceChannel.name} channel subscription status ===> ${presenceChannel.state?.status.name}');
      if (presenceChannel.state?.status.name == "subscribed" ||
          timer.tick == 5) {
        timer.cancel();
      }
    });
  }

  void notifyPrivateEventStatus(PrivateChannel privateChannel) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint(
          '${privateChannel.name} channel subscription status ===> ${privateChannel.state?.status.name}');
      if (privateChannel.state?.status.name == "subscribed" ||
          timer.tick == 5) {
        timer.cancel();
      }
    });
  }

  //////////////////// Event emitters
  void emitTypingEvent(Map<String, dynamic> eventData) {
    if (_messageDataChannel != null) {
      _messageDataChannel?.trigger(eventName: "client-typing", data: eventData);
    }
  }

  dispose() async {
    await client?.disconnect();
    client?.dispose();
    client = null;
    _activeCountChannel = null;
    _onlineChannel = null;
    _messageNotificationChannel = null;
    _messageDataChannel = null;
    _callEventChannel = null;
  }
}
