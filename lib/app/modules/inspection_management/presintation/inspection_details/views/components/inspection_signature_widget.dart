import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../components/inspection_details/inspection_info_card.dart';
import '../../controllers/inspection_details_controller.dart';

/// Captured inspector signature — same cached image and URL as before, inside
/// the page's themed surface.
class InspectionSignatureWidget extends GetView<InspectionDetailsController> {
  const InspectionSignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String url = controller.inspectionDetails.signature ?? '';

    return InspectionInfoCard(
      icon: Icons.draw_outlined,
      title: 'Inspector Signature',
      spacing: 0,
      children: [
        Semantics(
          image: true,
          label: 'Inspector signature',
          child: Container(
            height: 140,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: context.surfaceVariantColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.hairlineBorderColor),
            ),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    strokeCap: StrokeCap.round,
                    color: context.brandColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 22,
                      color: context.secondaryTextColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Signature unavailable',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
