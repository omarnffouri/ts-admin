import 'package:equatable/equatable.dart';

class CreateDropdownEntity extends Equatable {
  final List<Item>? types;
  final List<Item>? states;
  final List<Item>? lessors;

  const CreateDropdownEntity({
    this.types,
    this.states,
    this.lessors,
  });

  Map<String, dynamic> toEntity() => {
        "types": types == null
            ? []
            : List<dynamic>.from(types!.map((x) => x.toEntity())),
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toEntity())),
        "lessors": lessors == null
            ? []
            : List<dynamic>.from(lessors!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [types, states, lessors];
}

class Item extends Equatable {
  final String? id;
  final String? name;

  const Item({
    this.id,
    this.name,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];
}
