import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class LogoutEntity extends Equatable {
  late String? message;
  late int? code;

  LogoutEntity({this.message, this.code});

  factory LogoutEntity.fromJson(Map<String, dynamic> json) {
    return LogoutEntity(
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }

  @override
  List<Object?> get props => [message, code];
}
