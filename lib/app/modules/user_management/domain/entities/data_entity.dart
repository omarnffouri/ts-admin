import 'package:equatable/equatable.dart';

class DataEntity extends Equatable {
  final String? id;
  final String? title;
  final String? name;
  final String? createdAt;

  const DataEntity({
    this.id,
    this.title,
    this.name,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, name, createdAt];
}
