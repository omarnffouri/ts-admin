import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';

class DriverActionNoticeAttachmentsView
    extends GetView<FormDetailViewController> {
  const DriverActionNoticeAttachmentsView({
    super.key,
    required this.form,
  });

  final FormEntity form;

  @override
  Widget build(BuildContext context) {
    final List<_AttachmentGroupData> groups = <_AttachmentGroupData>[
      _AttachmentGroupData(
        label: 'Videos',
        attachmentType: FormAttachmentType.video,
        attachments: form.videos,
      ),
      _AttachmentGroupData(
        label: 'Attachments',
        attachmentType: FormAttachmentType.attachment,
        attachments: form.attachments,
      ),
      _AttachmentGroupData(
        label: 'Other Documents',
        attachmentType: FormAttachmentType.otherDocuments,
        attachments: form.otherDocuments,
      ),
    ]
        .where(
          (_AttachmentGroupData group) => group.attachments.isNotEmpty,
        )
        .toList(growable: false);

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool hasMultipleGroups = groups.length > 1;

    return Semantics(
      container: true,
      label: 'Files',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.tileColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.hairlineBorderColor),
          boxShadow: context.isDark
              ? null
              : [
                  BoxShadow(
                    color:
                        Theme.of(context).shadowColor.withValues(alpha: 0.045),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AttachmentSectionTitle(
              label: hasMultipleGroups ? 'Files' : groups.first.label,
              attachmentType: hasMultipleGroups
                  ? FormAttachmentType.none
                  : groups.first.attachmentType,
            ),
            const SizedBox(height: 8),
            for (int groupIndex = 0;
                groupIndex < groups.length;
                groupIndex++) ...[
              if (hasMultipleGroups)
                Padding(
                  padding: EdgeInsets.only(
                    top: groupIndex == 0 ? 4 : 14,
                    bottom: 4,
                  ),
                  child: Text(
                    groups[groupIndex].label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              for (int index = 0;
                  index < groups[groupIndex].attachments.length;
                  index++) ...[
                _DetailsAttachmentItem(
                  attachment: groups[groupIndex].attachments[index],
                  attachmentType: groups[groupIndex].attachmentType,
                  index: index,
                ),
                if (index != groups[groupIndex].attachments.length - 1)
                  Divider(
                    height: 1,
                    color: context.hairlineBorderColor,
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class FormAttachmentsView extends GetView<FormDetailViewController> {
  final FormEntity form;
  final String attachmentType;
  const FormAttachmentsView({
    super.key,
    required this.form,
    required this.attachmentType,
  });

  @override
  Widget build(BuildContext context) {
    final lable = attachmentType == FormAttachmentType.video
        ? "Videos"
        : attachmentType == FormAttachmentType.otherDocuments
            ? "Other Documents"
            : "Attachments";

    final list = (attachmentType == FormAttachmentType.video)
        ? form.videos
        : (attachmentType == FormAttachmentType.otherDocuments)
            ? form.otherDocuments
            : form.attachments;

    return Visibility(
      visible: list.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // videos heading
          Text(
            lable,
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ).marginOnly(left: 18, top: 10),

          //
          // videos list
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final attachment = list[index];
              return GestureDetector(
                onTap: () {
                  controller.launchAttachment(
                    attachment,
                    index,
                    attachmentType,
                  );
                },
                child: _FormAttachmentItemView(attachment: attachment)
                    .marginSymmetric(
                  vertical: 5,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider().marginOnly(
                left: 30,
              );
            },
          ).marginOnly(
            left: 14,
            right: 14,
            top: 5,
          )
        ],
      ),
    );
  }
}

class _AttachmentSectionTitle extends StatelessWidget {
  const _AttachmentSectionTitle({
    required this.label,
    required this.attachmentType,
  });

  final String label;
  final String attachmentType;

  @override
  Widget build(BuildContext context) {
    final IconData icon = attachmentType == FormAttachmentType.none
        ? Icons.folder_open_outlined
        : attachmentType == FormAttachmentType.video
            ? Icons.video_library_outlined
            : attachmentType == FormAttachmentType.otherDocuments
                ? Icons.folder_copy_outlined
                : Icons.attach_file_rounded;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.brandColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: context.brandColor),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentGroupData {
  const _AttachmentGroupData({
    required this.label,
    required this.attachmentType,
    required this.attachments,
  });

  final String label;
  final String attachmentType;
  final List<FormAttachmentEntity> attachments;
}

class _DetailsAttachmentItem extends GetView<FormDetailViewController> {
  const _DetailsAttachmentItem({
    required this.attachment,
    required this.attachmentType,
    required this.index,
  });

  final FormAttachmentEntity attachment;
  final String attachmentType;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String title = (attachment.title?.trim().isNotEmpty ?? false)
        ? attachment.title!
        : 'N/A';
    final String seenDate = attachment.seenAt.formatDateOrNA();

    return Semantics(
      button: true,
      label: '$title, $seenDate',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.launchAttachment(
              attachment,
              index,
              attachmentType,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: context.surfaceVariantColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    controller.fileExtensionHelper.getFileIcon(
                      controller.fileExtensionHelper.getFileType(
                        attachment.url ?? '',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        softWrap: true,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        seenDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                  color: context.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormAttachmentItemView extends GetView<FormDetailViewController> {
  final FormAttachmentEntity attachment;
  const _FormAttachmentItemView({
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        //
        //
        // icon

        Image.asset(
          controller.fileExtensionHelper.getFileIcon(
            controller.fileExtensionHelper.getFileType(
              attachment.url ?? "",
            ),
          ),
          width: 25,
          height: 25,
        ).marginOnly(right: 5),

        // Icon(
        //   Icons.video_collection_rounded,
        //   color: video.seenAt == null ? AppColorsLight.mainColor : Colors.grey,
        //   size: 24,
        // ).marginOnly(right: 5),

        //
        //
        // video name
        Expanded(
          child: Text(
            attachment.title ?? "",
            style: theme.textTheme.titleMedium?.copyWith(
              color: attachment.seenAt == null
                  ? AppColorsLight.mainColor
                  : Colors.green,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
