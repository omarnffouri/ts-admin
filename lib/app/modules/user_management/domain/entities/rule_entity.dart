import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class RuleEntity extends Equatable {
  final String? id;
  final String? name;
  bool isSelected = false;

  RuleEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
