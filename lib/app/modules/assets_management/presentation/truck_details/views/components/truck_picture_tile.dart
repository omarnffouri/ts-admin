import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../controllers/truck_details_controller.dart';

class TruckPictureTile extends GetView<TruckDetailsController> {
  const TruckPictureTile({
    super.key,
    required this.picture,
    required this.isDeleteEnabled,
    this.onDelete,
  });

  final FileEntity picture;
  final bool isDeleteEnabled;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final String url = picture.url ?? "";
    final String name = picture.fileName ?? picture.name ?? 'Truck picture';
    final bool canDelete = isDeleteEnabled && onDelete != null;

    return Stack(
      children: [
        //
        // thumbnail
        Positioned.fill(
          child: Semantics(
            button: true,
            label: 'Open picture $name',
            child: ExcludeSemantics(
              child: Material(
                color: context.surfaceVariantColor,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: context.hairlineBorderColor),
                ),
                child: InkWell(
                  onTap: () {
                    controller.openFile(picture);
                  },
                  child: url.isEmpty
                      ? const _PicturePlaceholder(
                          icon: Icons.image_not_supported_outlined,
                        )
                      : CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, _) =>
                              const _PicturePlaceholder(
                            icon: Icons.image_outlined,
                          ),
                          errorWidget: (context, _, __) =>
                              const _PicturePlaceholder(
                            icon: Icons.broken_image_outlined,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),

        //
        // download progress
        Positioned.fill(
          child: Obx(
            () => picture.isDownloading.value
                ? IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.applyOpacity(0.45),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            value: picture.downloadProgress.value,
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                            strokeWidth: 4,
                            semanticsLabel: 'Downloading picture',
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        //
        // delete
        if (canDelete)
          PositionedDirectional(
            top: 4,
            end: 4,
            child: Material(
              color: Colors.black.applyOpacity(0.45),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.white,
                    semanticLabel: 'Delete picture',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PicturePlaceholder extends StatelessWidget {
  const _PicturePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: context.surfaceVariantColor,
      child: Icon(icon, size: 22, color: context.tertiaryTextColor),
    );
  }
}
