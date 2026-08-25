import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';

import '../../controllers/create_announcement_controller.dart';

/// Rich text editor styled as a single card surface: a subtly tinted toolbar
/// strip on top, a hairline divider, then the writing area.
class DescriptionWidget extends GetView<CreateAnnouncementController> {
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color hairline = context.hairlineBorderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        //
        // heading
        Row(
          children: [
            Icon(Icons.notes_rounded,
                size: 16, color: context.secondaryTextColor),
            const SizedBox(width: 6),
            Text(
              "Description",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: context.brandColor),
            ),
          ],
        ),
        const SizedBox(height: 8),

        //
        //
        // html editor
        Container(
          decoration: BoxDecoration(
            color: context.fieldFillColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: hairline),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Column(
              children: [
                //
                // toolbar strip
                Container(
                  width: double.infinity,
                  color: context.surfaceVariantColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: QuillSimpleToolbar(
                    controller: controller.htmlController,
                    config: const QuillSimpleToolbarConfig(
                      showBackgroundColorButton: false,
                      color: Colors.transparent,
                      toolbarSectionSpacing: 4,
                      multiRowsDisplay: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showLink: false,
                      showIndent: false,
                      showInlineCode: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showSearchButton: false,
                      showListCheck: false,
                      showDividers: false,
                      showRedo: false,
                      showUndo: false,
                      showHeaderStyle: false,
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: hairline),

                //
                // writing area
                Obx(
                  () => LoadingWrapperWidget(
                    isLoading: controller.isLoading.value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: QuillEditor.basic(
                        controller: controller.htmlController,
                        config: QuillEditorConfig(
                          autoFocus: false,
                          placeholder: "Write the announcement details…",
                          onTapOutside: (event, focusNode) =>
                              focusNode.unfocus(),
                          minHeight: 200,
                          maxHeight: 250,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
