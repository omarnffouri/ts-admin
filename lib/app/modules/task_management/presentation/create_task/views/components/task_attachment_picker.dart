import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_task_controller.dart';

/// Attachment picker for the Create Task form: a labelled drop zone when no
/// file is selected, and a compact document card (name, type, size, replace
/// and remove actions) once one is. Mirrors the attachment pattern used on
/// the Create Announcement page.
class TaskAttachmentPicker extends GetView<CreateTaskController> {
  const TaskAttachmentPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final File? file = controller.confirmationFile.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
            child: child,
          ),
        ),
        child: file == null
            ? _EmptyDropZone(
                key: const ValueKey('empty'),
                onTap: controller.pickFile,
              )
            : _FileCard(key: ValueKey(file.path), file: file),
      );
    });
  }
}

class _EmptyDropZone extends StatelessWidget {
  const _EmptyDropZone({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;

    return Semantics(
      button: true,
      label: 'Add attachment',
      child: Material(
        color: accent.applyOpacity(dark ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: accent.applyOpacity(0.08),
          highlightColor: accent.applyOpacity(0.05),
          child: CustomPaint(
            painter: _DashedRRectPainter(
              color: accent.applyOpacity(dark ? 0.45 : 0.40),
              radius: 14,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: accent.applyOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.attach_file_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Choose File',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Optional attachment',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.tertiaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.applyOpacity(dark ? 0.18 : 0.12),
                    ),
                    child: Icon(Icons.add_rounded, size: 20, color: accent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileCard extends GetView<CreateTaskController> {
  const _FileCard({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;

    final String path = file.path;
    final String ext = controller.fileExtensionHelper.getFileExtension(path);
    final String name = controller.fileExtensionHelper.getFileName(
      path,
      withExtension: true,
    );
    final bool isImage = controller.confirmationFileIsImage();

    return Container(
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.panelBorderColor),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: controller.pickFile,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _Thumbnail(file: file, isImage: isImage, accent: accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (ext.isNotEmpty) ...[
                            _ExtBadge(ext: ext, accent: accent),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Obx(
                              () => Text(
                                controller.confirmationFileSize.value == null
                                    ? 'Tap to replace'
                                    : '${controller.confirmationFileSize.value} · replace',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.tertiaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: 'Remove attachment',
                  child: Material(
                    color:
                        Theme.of(context).colorScheme.error.applyOpacity(0.10),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: controller.removeConfirmationFile,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.file,
    required this.isImage,
    required this.accent,
  });

  final File file;
  final bool isImage;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (!isImage) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: accent.applyOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.insert_drive_file_rounded, color: accent, size: 24),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        file,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 56,
          height: 56,
          color: accent.applyOpacity(0.08),
          child: Icon(Icons.broken_image_outlined, color: accent, size: 24),
        ),
      ),
    );
  }
}

class _ExtBadge extends StatelessWidget {
  const _ExtBadge({required this.ext, required this.accent});

  final String ext;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: accent.applyOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        ext.toUpperCase(),
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border for the empty drop zone.
class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.color, this.radius = 14});

  final Color color;
  final double radius;
  static const double dash = 6;
  static const double gap = 5;
  static const double strokeWidth = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final Path path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}
