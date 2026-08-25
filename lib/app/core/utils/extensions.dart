import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/modules/shop_management/domain/entities/purchase_order_entity.dart';

import '../../modules/shop_management/domain/entities/service_order_entity.dart';

/// Hoisted — [decimalPattern] runs per list row, per build.
final RegExp _thousandsSeparator = RegExp(r'(\d)(?=(\d{3})+(?!\d))');

extension StatusFormatter on String {
  String formatStatus() {
    return replaceAll('_', '-')
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String toTitleCase() {
    return toLowerCase()
        .replaceAll(RegExp(r'[-_\s]'), ' ')
        .split(' ')
        .map((word) => word.capitalizeFirst!)
        .join(' ');
  }

  bool isNullOrEmpty() {
    return isEmpty || this == 'null';
  }

  bool isNotNullOrEmpty() {
    return isNotEmpty;
  }

  String dollar() {
    return '\$$this';
  }

  String decimalPattern() {
    if (isNullOrEmpty()) return '';
    try {
      return num.parse(this)
          .toStringAsFixed(2)
          .replaceAllMapped(_thousandsSeparator, (Match m) => '${m[1]},');
    } catch (e) {
      return '';
    }
  }

  String twoDigits() {
    return num.parse(this).toStringAsFixed(2);
  }

  String cleanDateOnly() {
    return split(' ').first;
  }
}

extension Times on DateTime? {
  String formatTime({bool hours12Format = true}) {
    if (this == null) {
      return "N/A";
    }
    return DateFormat(hours12Format ? 'hh:mm a' : 'HH:mm').format(this!);
  }

  String formatDateOrNA() {
    if (this == null) {
      return "N/A";
    }
    return DateFormat('MM/dd/yyyy').format(this!);
  }

  String getDDMMMYYYY() {
    if (this == null) {
      return "N/A";
    }
    return DateFormat('dd-MMM-yyyy').format(this!);
  }

  //
  //
  /// this will return a MMM-dd-yyyy format of date
  /// you can also pass true useSlash for making it MMM/dd/yyyy,
  /// by default useSlash is false
  String getMMMddYYYY({bool useSlash = false}) {
    if (this == null) {
      return "N/A";
    }
    final String sepration = useSlash ? "/" : "-";
    return DateFormat('MMM${sepration}dd${sepration}yyyy').format(this!);
  }

  //
  //
  /// this will return a MMM-dd-yyyy format of date
  /// you can also pass true dashDateSeprator for making it MMM-dd-yyyy,
  /// by default dashDateSeprator is false and
  /// pass true dashTimeSeprator for making time sepration (date-time) if false it will be (date at time),
  /// by default dashTimeSeprator is false and setting hours12Format to true will return a (hh:mm a) and
  /// if set to false will return a (HH:MM), by default its true
  String getDateMDYAndTime(
      {bool dashDateSeprator = false,
      bool dashTimeSeprator = false,
      bool hours12Format = true}) {
    if (this == null) {
      return "N/A";
    }
    final String sepration = dashDateSeprator ? "-" : "/";
    final dateFormat = 'MMM${sepration}dd${sepration}yyyy';
    final dateTimeSeperator = dashTimeSeprator ? ' - ' : ' at ';
    final timeFormat = hours12Format ? 'h:mm a' : 'HH:mm';

    // Format the date and time separately, then concatenate them
    final String formattedDate = DateFormat(dateFormat).format(this!);
    final String formattedTime = DateFormat(timeFormat).format(this!);

    // Combine the formatted date and time with the correct separator
    return '$formattedDate$dateTimeSeperator$formattedTime';
  }
}

extension ServiceDetailExtensions on ServiceDetailEntity {
  bool isApproved() {
    return status == 'approved';
  }

  bool isPending() {
    return status == 'pending';
  }

  bool isRejected() {
    return status == 'rejected';
  }
}

extension ServiceOrderExtensions on ServiceOrderEntity {
  bool isEnabled() {
    return status == 'pending_confirmation';
  }

  bool isRejected() {
    return status == 'rejected';
  }
}

extension PurchaseOrderExtensions on PurchaseOrderEntity {
  bool isPending() {
    return status == 'pending';
  }

  bool isRejected() {
    return status == 'rejected';
  }
}

extension AssetsManagment on String {
  String formatCollectionType() {
    return split('_') // Split on underscores
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() +
                word.substring(1).toLowerCase()) // Capitalize
        .join(' ');
  }
}

extension ColorAplha on Color {
  Color applyOpacity(double opacity) {
    return withAlpha((255.0 * opacity).round());
  }
}
