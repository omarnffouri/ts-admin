import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../../domain/entities/teams_entity.dart';
import '../components/multiple_search_dropdown.dart';

class AddNewNoteBottomSheet extends StatelessWidget {
  const AddNewNoteBottomSheet({
    super.key,
    required this.noteController,
    required this.isAddingNote,
    required this.showTeams,
    required this.onPressed,
    this.isPrivateSelected,
    this.isNotificationSelected,
    this.teams,
    this.onPickedChanged,
  });
  final TextEditingController noteController;
  final RxBool isAddingNote;
  final RxBool? isPrivateSelected;
  final RxBool? isNotificationSelected;
  final bool showTeams;
  final void Function() onPressed;
  final List<TeamsEntity>? teams;
  final void Function(List<TeamsEntity>)? onPickedChanged;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          //
          // top header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 50,
            decoration: const BoxDecoration(
              color: AppColorsLight.mainColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Text(
                  "Add Note",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                //
                //
                // close button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          if (showTeams)
            MultipleSearchDropdown(
              items: teams ?? [],
              onPickedChanged: onPickedChanged,
            ),

          //
          //
          // comment

          RoundedInputField(
            label: "Note",
            hintText: "Note",
            maxLength: 500,
            maxLines: 5,
            minLines: 5,
            showCounting: true,
            isRequired: true,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Comment is required";
              }
              return null;
            },
            controller: noteController,
            contentPadding: const EdgeInsets.all(10),
          ).marginOnly(left: 14, right: 14, top: 20),

          const SizedBox(height: 10),
          if (showTeams)
            NotesToggleButtons(
              isPrivateSelected: isPrivateSelected,
              isNotificationSelected: isNotificationSelected,
            ).marginSymmetric(horizontal: 14),

          // update status button
          Obx(
            () => MainAppButton(
              label: "Add",
              isLoading: isAddingNote.value,
              onPressed: onPressed,
            ),
          ).marginOnly(left: 14, right: 14, top: 10, bottom: 30),
        ],
      ),
    );
  }
}

class NotesToggleButtons extends StatelessWidget {
  const NotesToggleButtons({
    super.key,
    this.isPrivateSelected,
    this.isNotificationSelected,
  });

  final RxBool? isPrivateSelected;
  final RxBool? isNotificationSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Obx(() => GestureDetector(
                onTap: () {
                  isPrivateSelected?.toggle();
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: isPrivateSelected?.value,
                      onChanged: (value) => isPrivateSelected?.value = value!,
                      activeColor: Colors.red,
                    ),
                    Text(
                      "Make it private",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isPrivateSelected?.value ?? false
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(width: 30),
          Obx(() => GestureDetector(
                onTap: () {
                  isNotificationSelected?.toggle();
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: isNotificationSelected?.value,
                      onChanged: (value) =>
                          isNotificationSelected?.value = value!,
                      activeColor: Colors.red,
                    ),
                    Text(
                      "Send notification",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isNotificationSelected?.value ?? false
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
