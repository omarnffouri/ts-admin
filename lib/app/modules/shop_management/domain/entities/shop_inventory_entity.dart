import 'package:equatable/equatable.dart';

import 'supplier_entity.dart';

class ShopInventoryEntity extends Equatable {
  final int? id;
  final String? itemNumber;
  final String? itemName;
  final int quantity;
  final String? purchaseTax;
  final String? buyingPrice;
  final String? markupPrice;
  final String? sellingPrice;
  final String? requestedCount;
  final String? soldCount;
  final String? total;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SupplierEntity? supplier;

  const ShopInventoryEntity({
    this.id,
    this.itemNumber,
    this.itemName,
    this.quantity = 0,
    this.purchaseTax,
    this.buyingPrice,
    this.markupPrice,
    this.sellingPrice,
    this.requestedCount,
    this.soldCount,
    this.total,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.supplier,
  });

  @override
  List<Object?> get props => [
        id,
        itemNumber,
        itemName,
        quantity,
        purchaseTax,
        buyingPrice,
        markupPrice,
        sellingPrice,
        requestedCount,
        soldCount,
        total,
        isActive,
        createdAt,
        updatedAt,
        supplier,
      ];
}
