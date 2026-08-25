enum ChatInfoTags {
  driver("!", "driver"),
  truck("/", "truck"),
  shipment("\$", "shipment");

  final String symbol;
  final String name;
  const ChatInfoTags(this.symbol, this.name);

  static ChatInfoTags? fromString(String symbol) {
    for (var tag in ChatInfoTags.values) {
      if (tag.symbol == symbol) {
        return tag;
      }
    }
    return null;
  }
}

enum TruckLinkedTags {
  drivers,
  shipments,
}

enum DriverLinkedTags {
  trucks,
  shipments,
}

enum ShipmentLinkedTags {
  drivers,
  trucks,
}
