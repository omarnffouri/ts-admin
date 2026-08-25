import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';

import '../../../../domain/entities/requested_document_entity.dart';
import '../../controllers/application_detail_view_controller.dart';

class RequestedDocumentWidget extends GetView<ApplicationDetailViewController> {
  const RequestedDocumentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final requestedDocs = controller.requestedDocuments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requested Documents',
          style: Get.theme.textTheme.titleLarge,
        ).marginOnly(left: 14, top: 20),
        Divider(
          height: 0,
          color: Get.isDarkMode ? Colors.grey : null,
        ).marginSymmetric(horizontal: 14),
        const SizedBox(height: 20),
        if (requestedDocs.isEmpty)
          const SizedBox(
            height: 145,
            child: NoDataView(),
          ),
        if (requestedDocs.isNotEmpty)
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: requestedDocs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final document = requestedDocs[index];
              return RequestedDocumentItem(
                index: index,
                document: document,
                isFirst: index == 0,
                isLast: index == requestedDocs.length - 1,
              );
            },
          ),
      ],
    );
  }
}

class RequestedDocumentItem extends StatelessWidget {
  final int index;
  final RequestedDocumentEntity document;
  final bool isFirst;
  final bool isLast;
  final bool isPickup;

  const RequestedDocumentItem({
    super.key,
    required this.index,
    required this.document,
    this.isFirst = false,
    this.isLast = false,
    this.isPickup = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildRowTop(context),
        buildRowBottom(context),
      ],
    );
  }

  Widget buildRowTop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          document.isUploaded == true
              ? Icons.check_circle
              : Icons.pending_sharp,
          color: document.isUploaded == true
              ? Colors.lightGreen.shade600
              : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            document.fileName ?? '',
            style: Get.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: document.isUploaded == true
                ? Colors.lightGreen.shade600
                : Colors.orange,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            document.isUploaded == true ? 'Uploaded' : 'Pending',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  IntrinsicHeight buildRowBottom(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildVerticalLine(context),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [SizedBox(height: 10)],
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Opacity buildVerticalLine(BuildContext context) {
    return Opacity(
      opacity: isLast ? 0.0 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
        width: 2.0,
        color: Get.isDarkMode ? Colors.white54 : Colors.black12,
      ),
    );
  }

  Widget buildBadge({Widget? icon, String? val}) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white54 : Colors.black12,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon?.marginOnly(right: 5) ?? const SizedBox.shrink(),
          Text(
            val ?? '',
            style: Get.theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
