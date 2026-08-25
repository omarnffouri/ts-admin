import '../../domain/entities/shop_inventory_entity.dart';
import 'supplier_model.dart';

class ShopInventoryModel extends ShopInventoryEntity {
  const ShopInventoryModel({
    super.id,
    super.itemNumber,
    super.itemName,
    super.quantity,
    super.purchaseTax,
    super.buyingPrice,
    super.markupPrice,
    super.sellingPrice,
    super.requestedCount,
    super.soldCount,
    super.total,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.supplier,
  });

  factory ShopInventoryModel.fromJson(Map<String, dynamic> json) =>
      ShopInventoryModel(
        id: json["id"],
        itemNumber: json["item_number"],
        itemName: json["item_name"],
        quantity: json["quantity"],
        purchaseTax: json["purchase_tax"],
        buyingPrice: json["buying_price"],
        markupPrice: json["markup_price"],
        sellingPrice: json["selling_price"],
        requestedCount: json["requested_inventory_count"].toString(),
        soldCount: json["sold_inventory_count"].toString(),
        total: json["total"],
        isActive: json["status"] == "active",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        supplier: json["supplier"] == null
            ? null
            : SupplierModel.fromJson(json["supplier"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_number": itemNumber,
        "item_name": itemName,
        "quantity": quantity,
        "purchase_tax": purchaseTax,
        "buying_price": buyingPrice,
        "markup_price": markupPrice,
        "selling_price": sellingPrice,
        "requested_inventory_count": requestedCount,
        "sold_inventory_count": soldCount,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "supplier": supplier?.toEntity(),
      };
}
