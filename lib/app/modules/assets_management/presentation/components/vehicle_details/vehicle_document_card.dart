import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../domain/entities/vehicle_details_entity.dart';
import 'document_status_badge.dart';
import 'vehicle_meta_row.dart';

class VehicleDocumentCard extends StatelessWidget {
  const VehicleDocumentCard({
    super.key,
    required this.document,
    required this.fileExtensionHelper,
    required this.isDeleteEnabled,
    required this.isUploadEnabled,
    required this.onDelete,
    required this.onOpen,
    required this.onUpload,
    required this.onExpirationDate,
  });

  final DocumentDto document;
  final FileExtensionHelper fileExtensionHelper;
  final bool isDeleteEnabled;
  final bool isUploadEnabled;
  final Function(BuildContext)? onDelete;
  final VoidCallback onOpen;
  final VoidCallback? onUpload;
  final ValueChanged<String> onExpirationDate;

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.redAccent,
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onExpirationDate(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  String? _value(String? raw) {
    final String? value = raw?.trim();
    return value == null || value.isEmpty || value == 'null' ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isUploaded = document.isUploaded == true;

    // unchanged rule: an expirable document with a file but no date yet is the
    // only case that offers the expiration action
    final bool canAddExpiration = document.hasExpiration == true &&
        document.expirationDate == null &&
        document.file != null;

    final String? uploadedBy = _value(document.file?.uploadedBy);
    final String? deletedBy = _value(document.file?.deletedBy);
    final String? lastModified = _value(document.updatedAt);

    return Slidable(
      key: ValueKey(document.file?.id),
      closeOnScroll: false,
      enabled: isDeleteEnabled && document.isUploaded == true,
      groupTag: "document_listing_slide_group",
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const BehindMotion(),
        children: [
          // delete button
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: context.brandColor,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            label: 'Delete',
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (document.isUploaded == true) {
              onOpen();
            } else if (document.isUploaded == false && isUploadEnabled) {
              onUpload?.call();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.tileColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.hairlineBorderColor),
              boxShadow: context.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.applyOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // file type glyph / download progress
                DocumentFileGlyph(
                  document: document,
                  fileExtensionHelper: fileExtensionHelper,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // document name
                      Text(
                        document.collectionName ?? "",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: context.primaryTextColor,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 8),

                      //
                      // availability + expiration
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          DocumentStatusBadge.availability(
                            isUploaded: isUploaded,
                          ),
                          if (canAddExpiration)
                            _AddExpirationButton(
                              onPressed: () => _selectExpirationDate(context),
                            )
                          else
                            DocumentStatusBadge.expiration(
                              label: document.hasExpiration == true
                                  ? document.expirationDate ?? 'N/A'
                                  : "Non Expirable",
                              hasExpiration: document.hasExpiration == true,
                              isUploaded: isUploaded,
                            ),
                        ],
                      ),

                      //
                      // uploaded by
                      if (document.isUploaded == true)
                        VehicleMetaRow(
                          icon: Icons.person_outline_rounded,
                          label: "Uploaded by",
                          value: uploadedBy,
                        ),

                      //
                      // last modified
                      VehicleMetaRow(
                        icon: Icons.schedule_rounded,
                        label: "Last modified",
                        value: lastModified?.replaceFirst(" ", " at "),
                      ),

                      //
                      // deleted by
                      if (document.file?.deletedBy != null)
                        VehicleMetaRow(
                          icon: Icons.delete_outline_rounded,
                          label: "Deleted by",
                          value: deletedBy,
                        ),
                    ],
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

/// Leading glyph of a document card: the file-type icon once a file exists,
/// its download progress while the file is being fetched, or a neutral
/// placeholder for a document that has not been uploaded yet.
class DocumentFileGlyph extends StatelessWidget {
  const DocumentFileGlyph({
    super.key,
    required this.document,
    required this.fileExtensionHelper,
  });

  final DocumentDto document;
  final FileExtensionHelper fileExtensionHelper;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    final bool hasFile = (document.file?.url ?? "").isNotEmpty;

    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: hasFile
          ? Obx(
              () => document.file!.isDownloading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: document.file!.downloadProgress.value,
                        color: context.brandColor,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 4,
                        semanticsLabel: 'Downloading document',
                      ),
                    )
                  : Image.asset(
                      fileExtensionHelper.getFileIcon(
                        fileExtensionHelper.getFileType(
                          document.file!.fileNameExt ?? "",
                        ),
                      ),
                      width: 24,
                      height: 24,
                    ),
            )
          : Icon(
              document.isUploaded == true
                  ? Icons.description_outlined
                  : Icons.upload_file_outlined,
              size: 20,
              color: context.tertiaryTextColor,
            ),
    );
  }
}

class _AddExpirationButton extends StatelessWidget {
  const _AddExpirationButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add expiration date',
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: context.brandColor
                    .applyOpacity(context.isDark ? 0.16 : 0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: context.brandColor.applyOpacity(0.28),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    size: 14,
                    color: context.isDark
                        ? Colors.white.applyOpacity(0.9)
                        : context.brandColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Add Expiration",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.isDark
                              ? Colors.white.applyOpacity(0.9)
                              : context.brandColor,
                          fontWeight: FontWeight.w700,
                        ),
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
