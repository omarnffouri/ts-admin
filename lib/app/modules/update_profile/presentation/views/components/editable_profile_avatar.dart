import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/auth/domain/entities/login_entity.dart';

import '../../controllers/update_profile_controller.dart';

/// Compact circular avatar with a single "change photo" action.
///
/// The picking pipeline is untouched: the button calls
/// `UpdateProfileController.pickImage()`, which still routes to the platform
/// picker, the cropper and `filePath` exactly as before. The only extra state
/// read here is the existing `isUpdatingProfile` flag, used to show the upload
/// overlay while the update request (which carries the image) is in flight.
class EditableProfileAvatar extends GetView<UpdateProfileController> {
  const EditableProfileAvatar({super.key});

  static const double _avatarSize = 100;
  static const double _actionSize = 44;
  static const double _boxSize = _avatarSize + 12;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Obx(() {
        final String? pickedPath = controller.filePath.value;
        final bool hasPickedImage = pickedPath != null && pickedPath.isNotEmpty;
        final UserEntity? user = controller.authController.user.value;
        final bool isUploading = controller.isUpdatingProfile;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _boxSize,
              height: _boxSize,
              child: Stack(
                children: [
                  //
                  // avatar
                  Align(
                    child: _Avatar(
                      pickedPath: hasPickedImage ? pickedPath : null,
                      imageUrl: user?.image ?? "",
                      initials: _initialsOf(user),
                      isUploading: isUploading,
                    ),
                  ),

                  //
                  // change-photo action
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: _ChangePhotoButton(
                      enabled: !isUploading,
                      onTap: controller.pickImage,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            //
            // helper caption / picked-photo confirmation
            if (hasPickedImage)
              const _PickedPhotoBadge()
            else
              Text(
                'Tap the camera icon to change your photo',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.tertiaryTextColor,
                ),
              ),
          ],
        );
      }),
    );
  }

  /// Initials for the letter placeholder, built defensively so a missing or
  /// empty name can never throw (the previous `firstName[0]` could).
  String _initialsOf(UserEntity? user) {
    final String first = user?.firstName?.trim() ?? '';
    final String last = user?.lastName?.trim() ?? '';

    final StringBuffer buffer = StringBuffer();
    if (first.isNotEmpty) {
      buffer.write(first.characters.first);
    }
    if (last.isNotEmpty) {
      buffer.write(last.characters.first);
    }

    return buffer.toString().toUpperCase();
  }
}

/// The image itself: the newly picked file when there is one, otherwise the
/// stored profile photo — both falling back to the shared letter placeholder.
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.pickedPath,
    required this.imageUrl,
    required this.initials,
    required this.isUploading,
  });

  final String? pickedPath;
  final String imageUrl;
  final String initials;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final String? path = pickedPath;

    return Semantics(
      image: true,
      label: 'Profile photo',
      child: Container(
        width: EditableProfileAvatar._avatarSize,
        height: EditableProfileAvatar._avatarSize,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.surfaceColor,
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (path == null)
                ProfileImage.network(
                  url: imageUrl,
                  width: EditableProfileAvatar._avatarSize,
                  height: EditableProfileAvatar._avatarSize,
                  showLetterOnError: true,
                  letter: initials,
                )
              else
                ProfileImage.file(
                  file: File(path),
                  width: EditableProfileAvatar._avatarSize,
                  height: EditableProfileAvatar._avatarSize,
                  showLetterOnError: true,
                  letter: initials,
                ),

              //
              // upload overlay — shown only while the existing update request
              // (the one that uploads the image) is running
              if (isUploading)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.applyOpacity(0.45),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Brand-colored circular button pinned to the avatar's trailing corner, with a
/// card-colored ring so it stays legible over any photo.
class _ChangePhotoButton extends StatelessWidget {
  const _ChangePhotoButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background =
        enabled ? context.brandColor : context.brandColor.applyOpacity(0.5);

    return Semantics(
      button: true,
      enabled: enabled,
      label: 'Change profile photo',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: Container(
            width: EditableProfileAvatar._actionSize,
            height: EditableProfileAvatar._actionSize,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(color: context.tileColor, width: 3),
            ),
            child: const Icon(
              Icons.photo_camera_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Confirms a newly picked photo is staged — icon plus text, so the state is
/// never carried by color alone.
class _PickedPhotoBadge extends StatelessWidget {
  const _PickedPhotoBadge();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.successColor.applyOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.successColor.applyOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 15,
            color: context.successColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'New photo selected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
