import '../../domain/entities/note_entity.dart';

class NoteDataModel extends NoteDataEntity {
  const NoteDataModel({
    super.id,
    super.text,
    super.type,
    super.isPrivate,
    super.userId,
    super.modelType,
    super.modelId,
    super.createdAt,
    super.updatedAt,
    super.firstName,
    super.lastName,
    super.user,
  });

  factory NoteDataModel.fromJson(Map<String, dynamic> json) => NoteDataModel(
        id: json["id"],
        text: json["text"],
        type: json["type"],
        isPrivate: json["is_private"],
        userId: json["user_id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        user:
            json["user"] == null ? null : NoteUserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
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
}

class NoteUserModel extends NoteUserEntity {
  const NoteUserModel({
    super.id,
    super.name,
    super.firstName,
    super.lastName,
    super.email,
    super.phone,
    super.image,
  });

  factory NoteUserModel.fromJson(Map<String, dynamic> json) => NoteUserModel(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "image": image,
      };
}
