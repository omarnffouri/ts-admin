import 'package:get_storage/get_storage.dart';
import 'package:ts_admin/app/core/helpers/shared_preferences_helper.dart';
import 'package:ts_admin/app/modules/auth/data/models/realtime_configuration_model.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/realtime_configuration_entity.dart';

class RealtimeConfigurationStorageHelper {
  static const String realtimeConfiguration = 'realtimeConfiguration';

  static Future<void> store(RealtimeConfiguration configuration) async {
    await Future.wait([
      GetStorage().write(realtimeConfiguration, configuration.toJson()),
      SharedPrefrencesHelper.storeRealtimeConfiguration(configuration),
    ]);
  }

  static RealtimeConfiguration? read() {
    final data = GetStorage().read(realtimeConfiguration);
    if (data is! Map) {
      return null;
    }

    return RealtimeConfigurationModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  static Future<void> clear() async {
    await Future.wait([
      GetStorage().remove(realtimeConfiguration),
      SharedPrefrencesHelper.clearRealtimeConfiguration(),
    ]);
  }
}
