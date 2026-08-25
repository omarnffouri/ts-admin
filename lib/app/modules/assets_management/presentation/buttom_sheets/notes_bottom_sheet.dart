import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/no_data.dart';

import '../../domain/entities/note_entity.dart';
import '../components/note_item_view.dart';
import '../trucks/controllers/trucks_controller.dart';

class NotesBottomSheet extends StatelessWidget {
  const NotesBottomSheet({
    super.key,
    required this.id,
    required this.model,
    required this.notes,
  });
  final String id;
  final String model;
  final List<NoteDataEntity> notes;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrucksController());
    return Column(
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
                "Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.showAddNewNoteBottomSheet(truckId: id);
                },
                icon: const Icon(
                  Icons.add_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ).marginOnly(left: 8),

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

        //
        //
        // no data view

        (notes.isNotEmpty)
            ? Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.75,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    // notes
                    final note = notes[index];

                    return NoteItemView(
                      note: note,
                      index: index,
                    ).marginOnly(
                      top: index == 0 ? 10 : 0,
                      bottom: index == (notes.length) ? 30 : 0,
                    );
                  },
                ),
              )
            : const NoDataView(),
      ],
    );
  }
}
