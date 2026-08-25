import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/pdf_viewer.dart';

import '../../../../domain/enitities/shipment_details_entity.dart';
import '../../controllers/shipment_details_controller.dart';
import 'shipment_section_card.dart';

class ShipmentDocumentsSection extends GetView<ShipmentDetailsController> {
  const ShipmentDocumentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Files? files = controller.shipmentDetails?.files;
      final categories = <String, List<Confirmation>>{
        'Confirmation': files?.confirmation ?? [],
        'POD': files?.proofOfDelivery ?? [],
        'Fuel': files?.fuel ?? [],
        'Lumper': files?.lumper ?? [],
        'Invoiced': files?.invoiced ?? [],
        'Others': files?.others ?? [],
      }..removeWhere((_, items) => items.isEmpty);

      return ShipmentSectionCard(
        title: 'Documents',
        icon: Icons.folder_open_rounded,
        child: categories.isEmpty
            ? const ShipmentSectionEmptyMessage(
                message: 'No documents have been uploaded for this shipment.')
            : _DocumentsTabbedView(categories: categories),
      );
    });
  }
}

class _DocumentsTabbedView extends StatefulWidget {
  const _DocumentsTabbedView({required this.categories});

  final Map<String, List<Confirmation>> categories;

  @override
  State<_DocumentsTabbedView> createState() => _DocumentsTabbedViewState();
}

class _DocumentsTabbedViewState extends State<_DocumentsTabbedView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = widget.categories.keys.toList();
    final int index = _selectedIndex.clamp(0, titles.length - 1);
    final items = widget.categories[titles[index]]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: titles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final bool selected = i == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? context.brandColor
                        : context.surfaceVariantColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : context.hairlineBorderColor,
                    ),
                  ),
                  child: Text(
                    titles[i],
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: selected
                              ? Colors.white
                              : context.secondaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              ShipmentDocumentCard(document: items[i]),
              if (i != items.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class ShipmentDocumentCard extends StatelessWidget {
  const ShipmentDocumentCard({super.key, required this.document});

  final Confirmation document;

  bool get _isPdf =>
      (document.url?.split('.').last.toLowerCase() ?? '') == 'pdf';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String extension = document.url?.split('.').last.toUpperCase() ?? '';
    final String name = document.name?.trim().isNotEmpty ?? false
        ? document.name!.trim()
        : 'Document';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openDocument(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.surfaceVariantColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.hairlineBorderColor),
          ),
          child: Row(
            children: [
              _Thumbnail(document: document, isPdf: _isPdf),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (extension.isNotEmpty)
                          Text(
                            extension,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: context.tertiaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (document.createdAt != null)
                          Text(
                            document.createdAt!.formatDateOrNA(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: context.tertiaryTextColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: context.tertiaryTextColor),
            ],
          ),
        ),
      ),
    );
  }

  void _openDocument(BuildContext context) {
    final String url = document.url ?? '';
    if (url.isEmpty) return;

    if (_isPdf) {
      Get.to(
        () => PdfViewer(
          title: document.name ?? '',
          path: url,
          fileLoaded: () {},
        ),
      );
    } else {
      showImageDialog(context, url, title: document.name);
    }
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.document, required this.isPdf});

  final Confirmation document;
  final bool isPdf;

  static const double _size = 52;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _size,
        height: _size,
        child: isPdf
            ? Container(
                color: context.brandColor
                    .applyOpacity(context.isDark ? 0.18 : 0.10),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  size: 22,
                  color: context.isDark
                      ? Colors.white.applyOpacity(0.85)
                      : context.brandColor,
                ),
              )
            : CachedNetworkImage(
                imageUrl: document.url ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: context.isDark ? Colors.white10 : Colors.black12,
                  highlightColor:
                      context.isDark ? Colors.white24 : Colors.white30,
                  child: Container(color: context.surfaceColor),
                ),
                errorWidget: (context, url, error) => Container(
                  color: context.surfaceColor,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 20,
                    color: context.tertiaryTextColor,
                  ),
                ),
              ),
      ),
    );
  }
}
