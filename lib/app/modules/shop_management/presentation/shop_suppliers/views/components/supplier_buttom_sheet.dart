import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../../../domain/entities/supplier_entity.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class SupplierButtomSheet extends StatelessWidget {
  const SupplierButtomSheet({super.key, required this.supplier});

  final SupplierEntity supplier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Supplier Name
          Center(
            child: Text(
              supplier.name ?? 'No Name Provided',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Colors.grey[600],
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Colors.white.applyOpacity(0.1)
                  : Colors.grey[100],
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // Detailed Information
                _buildDetailRow('Representative', supplier.representative),
                _buildDetailRow('Phone', supplier.phone),
                _buildDetailRow('Email', supplier.email),
                _buildDetailRow('Address', supplier.address),
                _buildDetailRow('Tax Reference', supplier.taxReference),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Center(
            child: MainAppButton(
              label: "Close",
              isLoading: false,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper method to build a row of details in the bottom sheet
Widget _buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Get.textTheme.bodyMedium,
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: Get.textTheme.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
