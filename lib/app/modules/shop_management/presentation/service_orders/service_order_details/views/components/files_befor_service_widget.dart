import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../../domain/entities/service_order_entity.dart';
import '../../../../components/files_list_view.dart';

class FilesBeforServiceWidget extends StatelessWidget {
  const FilesBeforServiceWidget({super.key, required this.orderDetails});
  final ServiceDetailEntity? orderDetails;

  @override
  Widget build(BuildContext context) {
    if (orderDetails == null) {
      return const SizedBox.shrink();
    }
    if (orderDetails?.files!.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Divider(height: 1, color: context.hairlineBorderColor),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              size: 18,
              color: context.secondaryTextColor,
            ),
            const SizedBox(width: 7),
            Text(
              'Files Before Service',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FilesListView(
          files: orderDetails?.files ?? [],
        ),
      ],
    );
  }
}
