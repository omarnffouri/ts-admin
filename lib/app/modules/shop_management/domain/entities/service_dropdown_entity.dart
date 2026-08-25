import 'package:equatable/equatable.dart';

class ServiceDropdownEntity extends Equatable {
  final List<ServiceTypeEntity>? serviceType;
  final ClientsEntity? clients;
  final List<ItemEntity>? trailers;

  const ServiceDropdownEntity({
    this.serviceType,
    this.clients,
    this.trailers,
  });

  @override
  List<Object?> get props => [serviceType, clients, trailers];
}

class CategoryEntity extends Equatable {
  final String? name;

  const CategoryEntity({this.name});

  Map<String, dynamic> toEntity() => {
        "name": name,
      };

  @override
  List<Object?> get props => [name];
}

class ItemEntity extends Equatable {
  final int? id;
  final String? identifier;

  const ItemEntity({
    this.id,
    this.identifier,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "identifier": identifier,
      };

  @override
  List<Object?> get props => [id, identifier];
}

class ServiceTypeEntity extends Equatable {
  final String? code;
  final String? name;
  final List<DataEntity>? data;

  const ServiceTypeEntity({
    this.code,
    this.name,
    this.data,
  });

  Map<String, dynamic> toEntity() => {
        "code": code,
        "name": name,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [code, name, data];
}

class DataEntity extends Equatable {
  final String? code;
  final String? title;
  final String? value;

  const DataEntity({
    this.code,
    this.title,
    this.value,
  });

  Map<String, dynamic> toEntity() => {
        "code": code,
        "title": title,
        "value": value,
      };

  @override
  List<Object?> get props => [code, title, value];
}

class ClientsEntity {
  final List<ClientsItemEntity>? shopClients;
  final List<ClientsItemEntity>? companyClients;

  ClientsEntity({
    this.shopClients,
    this.companyClients,
  });

  Map<String, dynamic> toEntity() => {
        "shopClients": shopClients == null
            ? []
            : List<dynamic>.from(shopClients!.map((x) => x.toEntity())),
        "companyClients": companyClients == null
            ? []
            : List<dynamic>.from(companyClients!.map((x) => x.toEntity())),
      };
}

class ClientsItemEntity {
  final int? id;
  final String? companyName;
  final String? email;
  final List<ItemEntity>? trucks;
  final List<ItemEntity>? trailers;

  ClientsItemEntity({
    this.id,
    this.companyName,
    this.email,
    this.trucks,
    this.trailers,
  });

  Map<String, dynamic> toEntity() => {
        "id": id,
        "company_name": companyName,
        "email": email,
        "trucks": trucks == null
            ? []
            : List<dynamic>.from(trucks!.map((x) => x.toEntity())),
        "trailers": trailers == null
            ? []
            : List<dynamic>.from(trailers!.map((x) => x.toEntity())),
      };
}
