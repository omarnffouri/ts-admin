import 'package:equatable/equatable.dart';

class NoteDataEntity extends Equatable {
  final int? id;
  final String? text;
  final String? type;
  final int? isPrivate;
  final int? userId;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? firstName;
  final String? lastName;
  final NoteUserEntity? user;

  const NoteDataEntity({
    this.id,
    this.text,
    this.type,
    this.isPrivate,
    this.userId,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.user,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "text": text,
        "type": type,
        "is_private": isPrivate,
        "user_id": userId,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "user": user?.toEntity(),
      };

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        isPrivate,
        userId,
        modelType,
        modelId,
        createdAt?.toIso8601String(),
        updatedAt?.toIso8601String(),
        firstName,
        lastName,
        user,
      ];
}

class NoteUserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? image;

  const NoteUserEntity({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
        email,
        phone,
        image,
      ];

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "image": image,
      };
}
