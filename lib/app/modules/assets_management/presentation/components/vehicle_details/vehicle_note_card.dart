import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';

import '../../../domain/entities/note_entity.dart';
import 'section_empty_state.dart';

class VehicleNotesList extends StatelessWidget {
  const VehicleNotesList({
    super.key,
    required this.notes,
    required this.emptyMessage,
  });

  final List<NoteDataEntity> notes;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return SectionEmptyState(
        icon: Icons.sticky_note_2_outlined,
        title: 'No notes yet',
        message: emptyMessage,
        dense: true,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => VehicleNoteCard(
        note: notes[index],
        index: index,
      ),
    );
  }
}

class VehicleNoteCard extends StatelessWidget {
  const VehicleNoteCard({
    super.key,
    required this.note,
    required this.index,
  });

  final NoteDataEntity note;
  final int index;

  String get _authorName {
    final parts = <String?>[note.user?.firstName, note.user?.lastName]
        .map((part) => part?.trim() ?? '')
        .where((part) => part.isNotEmpty && part != 'null');

    final String name = parts.join(' ');
    return name.isEmpty ? 'Unknown user' : name;
  }

  String get _authorInitial {
    final String first = note.user?.firstName?.trim() ?? '';
    return first.isEmpty ? '' : (first[0].capitalizeFirst ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String text = note.text?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // author + date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImage.network(
                url: note.user?.image,
                width: 34,
                height: 34,
                showLetterOnError: true,
                letter: _authorInitial,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _authorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                note.createdAt.getDDMMMYYYY(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.tertiaryTextColor,
                ),
              ),
            ],
          ),

          //
          // note body
          if (text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.tileColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.hairlineBorderColor),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.primaryTextColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
