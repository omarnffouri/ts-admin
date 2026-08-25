import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';
import 'package:ts_admin/app/core/widgets/pdf_viewer.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_image_preview.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/previewers/chat_video_player.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/controllers/form_detail_view_controller.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AttachmentLauncher {
  Future<void> launch(FormAttachmentEntity formAttachmentEntity);
}

class VideoAttachmentLauncher extends AttachmentLauncher {
  @override
  Future<void> launch(FormAttachmentEntity formAttachmentEntity) async {
    try {
      Get.to(
        ChatVideoPlayer(
          videoUrl: formAttachmentEntity.url!,
          title: formAttachmentEntity.title!,
        ),
      );
    } catch (e) {
      debugPrint("Error launching video attachment: $e");
      rethrow;
    }
  }
}

class ImageAttachmentLauncher extends AttachmentLauncher {
  @override
  Future<void> launch(FormAttachmentEntity formAttachmentEntity) async {
    try {
      Get.to(
        () => ChatImagePreview(
          title: "Form attachment",
          previewImages: [
            PreviewImage(url: formAttachmentEntity.url, file: null)
          ],
          initialIndex: 0,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class PdfAttachmentLauncher extends AttachmentLauncher {
  @override
  Future<void> launch(FormAttachmentEntity formAttachmentEntity) async {
    try {
      Get.to(
        () => PdfViewer(
          title: "Form attachment",
          path: formAttachmentEntity.url!,
          fileLoaded: () {
            //
          },
          downloadable: true,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class UrlAttachmentLauncher extends AttachmentLauncher {
  @override
  Future<void> launch(FormAttachmentEntity formAttachmentEntity) async {
    try {
      await launchUrl(Uri.parse(formAttachmentEntity.url!));
    } catch (e) {
      rethrow;
    }
  }
}

class AttachmentLauncherFactory {
  static AttachmentLauncher getLauncher(
    FormAttachmentEntity formAttachmentEntity,
    String attachmentType,
  ) {
    if (attachmentType == FormAttachmentType.video) {
      return VideoAttachmentLauncher();
    } else {
      final isImageFile = FileExtensionHelper().isImageFile(
        lookupMimeType(formAttachmentEntity.url ?? "") ?? "",
      );

      if (isImageFile) {
        return ImageAttachmentLauncher();
      } else if (isPdfAttachment(formAttachmentEntity.url)) {
        return PdfAttachmentLauncher();
      } else {
        return UrlAttachmentLauncher();
      }
    }
  }

  static bool isPdfAttachment(String? url) {
    if (url == null) {
      false;
    }

    final ext = FileExtensionHelper().getFileExtension(
      FileExtensionHelper().getFileName(url!, withExtension: true),
    );
    return ext == "pdf";
  }
}
