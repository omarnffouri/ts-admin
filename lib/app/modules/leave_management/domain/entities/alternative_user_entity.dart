// To parse this JSON data, do
//
//     final supervisorModel = supervisorModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class AlternativeUserEntity extends Equatable {
  final int? id;
  final String? name;

  const AlternativeUserEntity({
    this.id,
    this.name,
  });

  AlternativeUserEntity copyWith({
    int? id,
    String? name,
  }) =>
      AlternativeUserEntity(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  @override
  List<Object?> get props => [id, name];
}
