import 'package:equatable/equatable.dart';

class UserTypeEntity extends Equatable {
  final List<ItemEntity>? applicants;
  final List<ItemEntity>? users;

  const UserTypeEntity({
    this.applicants,
    this.users,
  });

  Map<String, dynamic> toEntity() => {
        "applicants": applicants == null
            ? []
            : List<dynamic>.from(applicants!.map((x) => x.toEntity())),
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [applicants, users];
}

class ItemEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? image;

  const ItemEntity({
    this.id,
    this.name,
    this.email,
    this.image,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
      };

  @override
  List<Object?> get props => [id, name, email, image];
}
