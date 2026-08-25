import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Presentation-only lookup that turns the existing inspection `type` argument
/// ("driver" / "truck" / "trailer") into the labels and icons used by the
/// shared inspection form. Nothing here changes which entity is inspected — it
/// only decides how it is described on screen.
class InspectionTypeVisuals {
  const InspectionTypeVisuals._();

  static const String driver = 'driver';
  static const String truck = 'truck';
  static const String trailer = 'trailer';

  static String _normalize(String type) => type.trim().toLowerCase();

  /// Header title: "Driver Inspection", "Truck Inspection", ...
  static String pageTitle(String type) {
    switch (_normalize(type)) {
      case driver:
        return 'Driver Inspection';
      case truck:
        return 'Truck Inspection';
      case trailer:
        return 'Trailer Inspection';
    }

    final String label = type.trim();
    if (label.isEmpty) {
      return 'Inspection';
    }
    return '${label.capitalizeFirst ?? label} Inspection';
  }

  /// Short caption above the inspected subject on the summary card.
  static String subjectLabel(String type) {
    switch (_normalize(type)) {
      case driver:
        return 'Driver';
      case truck:
        return 'Truck';
      case trailer:
        return 'Trailer';
    }
    return 'Inspection subject';
  }

  static IconData subjectIcon(String type) {
    switch (_normalize(type)) {
      case driver:
        return Icons.person_rounded;
      case truck:
        return Icons.local_shipping_rounded;
      case trailer:
        return Icons.rv_hookup_rounded;
    }
    return Icons.assignment_turned_in_rounded;
  }

  /// Initials are only meaningful for people — units are identified by number.
  static bool showsInitials(String type) => _normalize(type) == driver;
}
