import 'package:equatable/equatable.dart';

class TeamsEntity extends Equatable {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? category;
  final String? title;
  final int? value;

  const TeamsEntity({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
    this.title,
    this.value,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "category": category,
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
        updatedAt,
        deletedAt,
        category,
        title,
        value,
      ];
}
