import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_admin/app/core/helpers/realtime_configuration_storage_helper.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/modules/auth/data/models/realtime_configuration_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory storageDirectory;
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() async {
    storageDirectory =
        await Directory.systemTemp.createTemp('realtime_configuration_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return storageDirectory.path;
      }
      return null;
    });
    GetStorage('GetStorage', storageDirectory.path);
    await GetStorage.init();
  });

  setUp(() async {
    await GetStorage().erase();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await GetStorage().erase();
  });

  // The path_provider mock stays installed for the life of the process, and
  // the temp directory is left to the OS. Both are forced by get_storage
  // 2.1.1: `StorageImpl._fileDb` calls `getApplicationDocumentsDirectory()` on
  // every file operation even when an explicit path was supplied, and
  // `_madeBackup()` fires that off untracked — so a write still lands after the
  // awaited future completes. Removing the mock (or deleting the directory)
  // makes that straggler throw *after* the test finished. The `.gs` file also
  // stays open: get_storage never closes its RandomAccessFile, so on Windows
  // the directory cannot be deleted anyway.

  test('parses websocket and Agora realtime configuration', () {
    final configuration = RealtimeConfigurationModel.fromJson(_payload());

    expect(configuration.appId, '946d4be62764967b');
    expect(configuration.key, '9dbf5c6a056f4d4f99561fcf43f8a566');
    expect(configuration.agora?.appId, '56ce6ab15eef486aa7b5b798c930042e');
    expect(configuration.configVersion, '2879411174');
    expect(configuration.toJson()['agora']['app_id'],
        '56ce6ab15eef486aa7b5b798c930042e');
  });

  test('stores full config and mirrors native Agora values', () async {
    final configuration = RealtimeConfigurationModel.fromJson(_payload());

    await RealtimeConfigurationStorageHelper.store(configuration);

    final storedConfiguration = RealtimeConfigurationStorageHelper.read();
    final prefs = await SharedPreferences.getInstance();

    expect(
        storedConfiguration?.agora?.appId, '56ce6ab15eef486aa7b5b798c930042e');
    expect(prefs.getString(SharedPrefrencesHelper.AgoraAppId),
        '56ce6ab15eef486aa7b5b798c930042e');
    expect(prefs.getString(SharedPrefrencesHelper.RealtimeConfigVersion),
        '2879411174');

    await RealtimeConfigurationStorageHelper.clear();

    expect(RealtimeConfigurationStorageHelper.read(), isNull);
    expect(prefs.getString(SharedPrefrencesHelper.AgoraAppId), isNull);
    expect(
        prefs.getString(SharedPrefrencesHelper.RealtimeConfigVersion), isNull);
  });
}

Map<String, dynamic> _payload() {
  return {
    'websocket': {
      'provider': 'reverb',
      'broadcaster': 'reverb',
      'app_id': '946d4be62764967b',
      'key': '9dbf5c6a056f4d4f99561fcf43f8a566',
      'host': 'dev.ts-portal.com',
      'port': 2096,
      'scheme': 'https',
      'path': '/app',
      'force_tls': true,
      'enabled_transports': ['ws', 'wss'],
      'auth_endpoint': 'https://dev.ts-portal.com/broadcasting/auth',
    },
    'agora': {
      'app_id': '56ce6ab15eef486aa7b5b798c930042e',
      'app_certificate': '050553eb53324630b6f45109028562d1',
      'app_customer_key': '99886b3f77214c82a3266d3635a76cc5',
      'app_customer_secret': '1fbf114464d84c4a84616b0bd2fabb5f',
      'notification_secret': 'I8kgGV9tb',
    },
    'config_version': '2879411174',
  };
}
