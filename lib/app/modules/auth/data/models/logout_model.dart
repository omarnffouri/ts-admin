import 'package:ts_admin/app/modules/auth/domain/entities/logout_entitiy.dart';

// ignore: must_be_immutable
class LogoutModel extends LogoutEntity {
  LogoutModel({super.message, super.code});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      message: json['message'],
      code: json['code'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }
}
