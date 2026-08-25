import '../../domain/entities/user_type_entity.dart';

class UserTypeModel extends UserTypeEntity {
  const UserTypeModel({
    super.applicants,
    super.users,
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) => UserTypeModel(
        applicants: json["applicants"] == null
            ? []
            : List<ItemModel>.from(
                json["applicants"]!.map((x) => ItemModel.fromJson(x))),
        users: json["users"] == null
            ? []
            : List<ItemModel>.from(
                json["users"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "applicants": applicants == null
            ? []
            : List<dynamic>.from(applicants!.map((x) => x.toEntity())),
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toEntity())),
      };
}

class ItemModel extends ItemEntity {
  const ItemModel({
    super.id,
    super.name,
    super.email,
    super.image,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
      };
}
