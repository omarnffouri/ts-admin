import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../../../../../domain/entities/service_order_entity.dart';
import '../../../../components/customer_info_widget.dart';
import '../../../../components/vehicle_info_widget.dart';

class CustomerDetailsButtomSheet extends StatelessWidget {
  const CustomerDetailsButtomSheet({super.key, required this.customer});

  final CustomerEntity customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomerInfoWidget(customerDetails: customer),
                  const SizedBox(height: 16),
                  VehicleInfoWidget(customerDetails: customer),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: MainAppButton(
              label: "Close",
              isLoading: false,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
