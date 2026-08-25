import 'package:ts_admin/app/modules/auth/domain/entities/app_configration_entity.dart';

class AppConfigurationModel extends AppConfiguration {
  const AppConfigurationModel({
    super.isOtpEnabled,
  });

  factory AppConfigurationModel.fromJson(Map<String, dynamic> json) =>
      AppConfigurationModel(
        isOtpEnabled: json["is_otp_enable"],
      );
}
