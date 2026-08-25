import '../../domain/entities/service_dropdown_entity.dart';

class ServiceDropdownModel extends ServiceDropdownEntity {
  const ServiceDropdownModel({
    super.serviceType,
    super.clients,
    super.trailers,
  });

  factory ServiceDropdownModel.fromJson(Map<String, dynamic> json) =>
      ServiceDropdownModel(
        serviceType: json["serviceType"] == null
            ? []
            : List<ServiceTypeModel>.from(
                json["serviceType"]!.map((x) => ServiceTypeModel.fromJson(x))),
        clients: json["clients"] == null
            ? null
            : ClientsModel.fromJson(json["clients"]),
        trailers: json["trailers"] == null
            ? []
            : List<ItemModel>.from(
                json["trailers"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serviceType": serviceType == null
            ? []
            : List<dynamic>.from(serviceType!.map((x) => x.toEntity())),
        "trailers": trailers == null
            ? []
            : List<dynamic>.from(trailers!.map((x) => x.toEntity())),
      };
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class ItemModel extends ItemEntity {
  const ItemModel({
    super.id,
    super.identifier,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        identifier: json["identifier"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
      };
}

class ServiceTypeModel extends ServiceTypeEntity {
  const ServiceTypeModel({
    super.code,
    super.name,
    super.data,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      ServiceTypeModel(
        code: json["code"],
        name: json["name"],
        data: json["data"] == null
            ? []
            : List<DataModel>.from(
                json["data"]!.map((x) => DataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toEntity())),
      };
}

class DataModel extends DataEntity {
  const DataModel({
    super.code,
    super.title,
    super.value,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        code: json["code"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "title": title,
        "value": value,
      };
}

class ClientsModel extends ClientsEntity {
  ClientsModel({
    super.shopClients,
    super.companyClients,
  });

  factory ClientsModel.fromJson(Map<String, dynamic> json) => ClientsModel(
        shopClients: json["shopClients"] == null
            ? []
            : List<ClientsItemModel>.from(
                json["shopClients"]!.map((x) => ClientsItemModel.fromJson(x))),
        companyClients: json["companyClients"] == null
            ? []
            : List<ClientsItemModel>.from(json["companyClients"]!
                .map((x) => ClientsItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shopClients": shopClients == null
            ? []
            : List<dynamic>.from(shopClients!.map((x) => x.toEntity())),
        "companyClients": companyClients == null
            ? []
            : List<dynamic>.from(companyClients!.map((x) => x.toEntity())),
      };
}

class ClientsItemModel extends ClientsItemEntity {
  ClientsItemModel({
    super.id,
    super.companyName,
    super.email,
    super.trucks,
    super.trailers,
  });

  factory ClientsItemModel.fromJson(Map<String, dynamic> json) =>
      ClientsItemModel(
        id: json["id"],
        companyName: json["company_name"],
        email: json["email"],
        trucks: json["trucks"] == null
            ? []
            : List<ItemModel>.from(
                json["trucks"]!.map((x) => ItemModel.fromJson(x))),
        trailers: json["trailers"] == null
            ? []
            : List<ItemModel>.from(
                json["trailers"]!.map((x) => ItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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
