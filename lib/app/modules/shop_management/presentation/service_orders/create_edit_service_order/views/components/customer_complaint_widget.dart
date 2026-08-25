import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';

import '../../controllers/create_edit_service_order_controller.dart';

class CustomerComplaintWidget
    extends GetView<CreateEditServiceOrderController> {
  const CustomerComplaintWidget({super.key, required this.isEnabled});
  final RxBool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingWrapperWidget(
        isLoading: controller.isLoading.value,
        child: IgnorePointer(
          ignoring: !isEnabled.value || controller.isLoading.value,
          child: Opacity(
            opacity: isEnabled.value || controller.isLoading.value ? 1 : 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.fieldFillColor,
                    border: Border.all(color: context.hairlineBorderColor),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Column(
                      children: [
                        QuillSimpleToolbar(
                          controller: controller.htmlController,
                          config: QuillSimpleToolbarConfig(
                            showBackgroundColorButton: false,
                            color: context.surfaceVariantColor,
                            toolbarSectionSpacing: 3,
                            toolbarIconAlignment: WrapAlignment.start,
                            toolbarSize: 42,
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
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: context.hairlineBorderColor,
                        ),
                        QuillEditor.basic(
                          controller: controller.htmlController,
                          config: QuillEditorConfig(
                            autoFocus: false,
                            placeholder: 'Describe the customer complaint…',
                            padding: const EdgeInsets.all(14),
                            onTapOutside: (event, focusNode) =>
                                focusNode.unfocus(),
                            minHeight: 160,
                            maxHeight: 220,
                          ),
                        ),
                      ],
                    ),
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
