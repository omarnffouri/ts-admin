import 'package:equatable/equatable.dart';

class DeviceTypeEntity extends Equatable {
  final int? id;
  final String? code;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? value;

  const DeviceTypeEntity({
    this.id,
    this.code,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.value,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "code": code,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [
        id,
        code,
        type,
        createdAt,
        updatedAt,
        title,
        value,
      ];
}
