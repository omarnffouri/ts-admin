import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/rounded_border_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_fill_button.dart';
import 'package:ts_admin/app/modules/media_picker_previewer/controllers/media_picker_previewer_controller.dart';

class ImageEditorBottomSheet extends StatefulWidget {
  final MediaPickerFile mediaPickerFile;
  const ImageEditorBottomSheet({
    super.key,
    required this.mediaPickerFile,
  });

  @override
  State<ImageEditorBottomSheet> createState() => _ImageEditorBottomSheetState();
}

class _ImageEditorBottomSheetState extends State<ImageEditorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ProImageEditor.file(
        widget.mediaPickerFile.orignalFile,
        // controller.mediaFiles.elementAt(0).orignalFile,
        configs: ProImageEditorConfigs(
          stateHistoryConfigs: widget.mediaPickerFile.editHistory != null
              ? StateHistoryConfigs(
                  initStateHistory: ImportStateHistory.fromMap(
                  widget.mediaPickerFile.editHistory!,
                ))
              : const StateHistoryConfigs(),
          customWidgets: ImageEditorCustomWidgets(
            mainEditor: CustomWidgetsMainEditor(
              appBar: (editor, rebuildStream) {
                return ReactiveCustomAppbar(
                  builder: (context) {
                    return AppBar(
                      leading: const SizedBox.shrink(),
                      leadingWidth: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          //
                          // undo button
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              if (editor.canUndo) {
                                editor.undoAction();
                              }
                            },
                            icon: Icon(
                              Icons.undo_rounded,
                              color: editor.canUndo
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),

                          //
                          //
                          // redo button
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              if (editor.canRedo) {
                                editor.redoAction();
                              }
                            },
                            icon: Icon(
                              Icons.redo_rounded,
                              color: editor.canRedo
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),

                          //
                          //
                          // filter button
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openFilterEditor();
                            },
                            icon: const Icon(
                              Icons.filter_rounded,
                              color: Colors.white,
                            ),
                          ),

                          //
                          //
                          // blur button
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openBlurEditor();
                            },
                            icon: const Icon(
                              Icons.blur_on_rounded,
                              color: Colors.white,
                            ),
                          ),

                          //
                          //
                          // crop rotate icon
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openCropRotateEditor();
                            },
                            icon: const Icon(
                              Icons.crop_rotate_rounded,
                              color: Colors.white,
                            ),
                          ),

                          //
                          //
                          // sticker icon
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openEmojiEditor();
                            },
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white,
                            ),
                          ),

                          //
                          //
                          // text icon
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openTextEditor();
                            },
                            icon: const Icon(
                              Icons.text_fields_rounded,
                              color: Colors.white,
                            ),
                          ),

                          //
                          //
                          // drawing icon
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              editor.openPaintingEditor();
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  stream: rebuildStream,
                );
              },
              bottomBar: (editor, rebuildStream, key) {
                return ReactiveCustomWidget(
                  builder: (context) {
                    return Row(
                      children: [
                        //
                        //
                        /// cancel Button
                        Expanded(
                          child: RoundedBorderButton(
                            label: "Cancel",
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            labelColor: Colors.white,
                            onPressed: () {
                              editor.closeEditor();
                            },
                          ),
                        ),

                        if (editor.canUndo || editor.canRedo)
                          const SizedBox(
                            width: 20,
                          ),

                        if (editor.canUndo || editor.canRedo)
                          Expanded(
                            child: RoundedFillButton(
                              label: "Done",
                              onPressed: () async {
                                final history =
                                    await editor.exportStateHistory();
                                widget.mediaPickerFile.editHistory =
                                    await history.toMap();
                                editor.doneEditing();
                              },
                            ),
                          ),
                      ],
                    ).marginSymmetric(horizontal: 14, vertical: 10);
                  },
                  stream: rebuildStream,
                );
              },
            ),
          ),
          imageEditorTheme: const ImageEditorTheme(
            helperLine: HelperLineTheme(
              horizontalColor: Colors.white,
              verticalColor: Colors.white,
              rotateColor: Colors.white,
            ),
            cropRotateEditor: CropRotateEditorTheme(
              helperLineColor: AppColorsLight.mainColor,
              cropCornerColor: AppColorsLight.mainColor,
            ),
            paintingEditor: PaintingEditorTheme(
              bottomBarActiveItemColor: AppColorsLight.mainColor,
            ),
            blurEditor: BlurEditorTheme(
              sliderActiveColor: AppColorsLight.mainColor,
            ),
            filterEditor: FilterEditorTheme(
              previewSelectedTextColor: AppColorsLight.mainColor,
              sliderActiveColor: AppColorsLight.mainColor,
            ),
          ),
        ),
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (Uint8List bytes) async {
            widget.mediaPickerFile.editedFile.value = bytes;
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
