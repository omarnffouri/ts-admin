import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../controllers/create_announcement_controller.dart';

class AnnouncementFileView extends GetView<CreateAnnouncementController> {
  const AnnouncementFileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(theme: theme),
          const SizedBox(height: 8),
          Obx(() {
            final file = controller.announcementFile.value;
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
                      onTap: () => controller
                          .showAnnouncementAttachmentBottomSheet(theme),
                    )
                  : _FileCard(key: ValueKey(file.path), file: file),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color muted = context.secondaryTextColor;
    return Row(
      children: [
        Icon(Icons.attach_file_rounded, size: 16, color: muted),
        const SizedBox(width: 6),
        Text(
          'Attachment',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(optional)',
          style: theme.textTheme.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}

class _EmptyDropZone extends StatelessWidget {
  const _EmptyDropZone({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;
    return Material(
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
                    Icons.cloud_upload_rounded,
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
                        'Add attachment',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Images only',
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
    );
  }
}

class _FileCard extends GetView<CreateAnnouncementController> {
  const _FileCard({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;

    final String path = file.path;
    final String ext = controller.fileExtensionHelper.getFileExtension(path);
    final String name = controller.fileExtensionHelper.getFileName(
      path,
      withExtension: true,
    );
    final String? size = controller.announcementFileSize.value;

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
          onTap: () => controller.showAnnouncementAttachmentBottomSheet(theme),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _Thumbnail(file: file, accent: accent),
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
                            child: Text(
                              size == null
                                  ? 'Tap to replace'
                                  : '$size · replace',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.tertiaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RemoveButton(onTap: controller.removeAnnouncementFile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.file, required this.accent});

  final File file;
  final Color accent;

  @override
  Widget build(BuildContext context) {
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

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red.applyOpacity(0.10),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border for the empty drop zone.
class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    this.radius = 14,
  });

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
