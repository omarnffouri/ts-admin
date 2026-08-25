import 'package:equatable/equatable.dart';

class InspectionDropdownEntity extends Equatable {
  final List<ItemEntity>? drivers;
  final List<ItemEntity>? trailers;
  final List<ItemEntity>? trucks;

  const InspectionDropdownEntity({
    this.drivers,
    this.trailers,
    this.trucks,
  });

  Map<String, dynamic> toEntity() => {
        "drivers": drivers == null
            ? []
            : List<dynamic>.from(drivers!.map((x) => x.toEntity())),
        "trailers": trailers == null
            ? []
            : List<dynamic>.from(trailers!.map((x) => x.toEntity())),
        "trucks": trucks == null
            ? []
            : List<dynamic>.from(trucks!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [drivers, trailers, trucks];
}

class ItemEntity extends Equatable {
  final int? id;
  final int? identifier;
  final String? driverName;

  const ItemEntity({
    this.id,
    this.identifier,
    this.driverName,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "identifier": identifier,
        "driver_name": driverName,
      };

  @override
  List<Object?> get props => [id, identifier, driverName];
}
