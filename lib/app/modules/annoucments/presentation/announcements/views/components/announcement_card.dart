import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_image_preview.dart';

import '../../../../domain/entities/annoucement_entity.dart';
import '../../controllers/annoucments_controller.dart';

const double _kBannerHeight = 168;
const BorderRadius _kCardRadius = BorderRadius.all(Radius.circular(18));
const EdgeInsets _kBodyPadding = EdgeInsets.fromLTRB(14, 12, 14, 12);

/// Strips tags/entities from the HTML body so the listing can render a cheap
/// text preview — full markup is only worth parsing on the detail preview.
final RegExp _htmlTag = RegExp(r'<[^>]*>');
final RegExp _whitespace = RegExp(r'\s+');

String _previewText(String? html) {
  if (html == null || html.isEmpty) return '';
  return html
      .replaceAll(_htmlTag, ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll(_whitespace, ' ')
      .trim();
}

/// One announcement in the listing: optional banner image, title, body preview,
/// and a footer with the age and the read state (mirrors the home-tab item).
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.index,
    required this.controller,
  });

  final AnnoucementEntity announcement;
  final int index;
  final AnnoucmentsController controller;

  void _openImagePreview() {
    final String? image = announcement.image;
    if (image == null) return;
    Get.to(
      ChatImagePreview(
        title: "Announcement",
        previewImages: [PreviewImage(url: image, file: null)],
        initialIndex: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = announcement.read != 1;
    final String preview = _previewText(announcement.message);

    return Container(
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: _kCardRadius,
        border: Border.all(color: context.hairlineBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          controller.updateAnnoucementsReadStatus(announcement, index);
          _openImagePreview();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.image != null)
              ProfileImage.network(
                url: announcement.image!,
                radius: 0,
                width: double.infinity,
                height: _kBannerHeight,
              ),
            Padding(
              padding: _kBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: AppColorsLight.mainColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          announcement.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: isUnread
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: context.primaryTextColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      preview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.secondaryTextColor,
                            height: 1.35,
                          ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeago.format(
                          announcement.createdAt ?? DateTime.now(),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      _ReadState(
                        announcement: announcement,
                        index: index,
                        controller: controller,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadState extends StatelessWidget {
  const _ReadState({
    required this.announcement,
    required this.index,
    required this.controller,
  });

  final AnnoucementEntity announcement;
  final int index;
  final AnnoucmentsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isUpdatingThis =
          controller.updatingAnnouncementStatusIndex.value == index &&
              controller.isupdatingAnnoucementStatus;

      if (isUpdatingThis) {
        return SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            strokeCap: StrokeCap.round,
            color: context.isDark ? Colors.white : AppColorsLight.mainColor,
          ),
        );
      }

      if (announcement.read == 1) {
        return const Icon(
          Icons.done_all_rounded,
          size: 18,
          color: Colors.green,
        );
      }

      return GestureDetector(
        onTap: () =>
            controller.updateAnnoucementsReadStatus(announcement, index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: context.isDark ? Colors.white : AppColorsLight.mainColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            "Read me",
            style: TextStyle(
              color: context.isDark ? AppColorsLight.mainColor : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}

/// Static loading skeleton matching [AnnouncementCard]'s shape block for block,
/// so the list doesn't reflow when real data lands. Lives beside the card and
/// shares its radius/padding/banner constants to stay in sync.
class AnnouncementCardSkeleton extends StatelessWidget {
  const AnnouncementCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bone = context.isDark ? Colors.white12 : Colors.black12;

    Widget bar(double width, double height) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: bone,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: _kCardRadius,
        border: Border.all(color: context.hairlineBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: _kBannerHeight,
            color: bone,
          ),
          Padding(
            padding: _kBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(180, 16),
                const SizedBox(height: 12),
                bar(double.infinity, 12),
                const SizedBox(height: 6),
                bar(220, 12),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bar(100, 12),
                    bar(70, 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
