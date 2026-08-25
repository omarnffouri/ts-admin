// To parse this JSON data, do
//
//     final supervisorModel = supervisorModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class SupervisorEntity extends Equatable {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;

  const SupervisorEntity({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
  });

  SupervisorEntity copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
  }) =>
      SupervisorEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  @override
  List<Object?> get props => [id, name, firstName, lastName];
}
