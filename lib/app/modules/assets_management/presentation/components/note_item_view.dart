import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../../domain/entities/note_entity.dart';

class NoteItemView extends StatelessWidget {
  final NoteDataEntity note;
  final int index;
  const NoteItemView({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDark = Get.isDarkMode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.applyOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.grey : Colors.black),
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: isDark ? .5 : .8,
          image: AssetImage(
            Assets.chatIcons.chatBackgroundCover.path,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImage.network(
                url: note.user?.image,
                width: 35,
                height: 35,
                showLetterOnError: true,
                letter: note.user?.firstName?[0].capitalizeFirst ?? '',
              ),
              Expanded(
                child: BubbleSpecialOne(
                  text: note.text ?? '',
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  tail: true,
                  isSender: false,
                  textStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "${note.user?.firstName} ${note.user?.lastName}",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColorsLight.mainColorLight,
                ),
              ),
              const Spacer(),
              Text(
                note.createdAt.getDDMMMYYYY(),
                style: theme.textTheme.labelMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
