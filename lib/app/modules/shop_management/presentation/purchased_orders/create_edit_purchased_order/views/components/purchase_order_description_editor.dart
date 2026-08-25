import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';

import '../../controllers/create_edit_purchased_order_controller.dart';

class PurchaseOrderDescriptionEditor
    extends GetView<CreateEditPurchasedOrderController> {
  const PurchaseOrderDescriptionEditor({super.key, required this.isEnabled});

  final RxBool isEnabled;

  static const double _toolbarSize = 42;

  @override
  Widget build(BuildContext context) {
    final Color hairline = context.hairlineBorderColor;

    return Obx(
      () => IgnorePointer(
        ignoring: !isEnabled.value || controller.isLoading.value,
        child: Opacity(
          opacity: isEnabled.value || controller.isLoading.value ? 1 : 0.5,
          child: Container(
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
                  //
                  // toolbar strip — scrolls horizontally so every control stays
                  // reachable on small screens instead of being clipped
                  Semantics(
                    container: true,
                    label: 'Description formatting toolbar',
                    child: Container(
                      width: double.infinity,
                      color: context.surfaceVariantColor,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: QuillSimpleToolbar(
                        controller: controller.htmlController,
                        config: QuillSimpleToolbarConfig(
                          showBackgroundColorButton: false,
                          color: Colors.transparent,
                          toolbarSize: _toolbarSize,
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
                          buttonOptions: QuillSimpleToolbarButtonOptions(
                            base: QuillToolbarBaseButtonOptions(
                              iconTheme: _iconTheme(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: hairline),

                  //
                  //
                  // writing area
                  LoadingWrapperWidget(
                    isLoading: controller.isLoading.value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: QuillEditor.basic(
                        controller: controller.htmlController,
                        config: QuillEditorConfig(
                          autoFocus: false,
                          placeholder: 'Write the purchase order details…',
                          onTapOutside: (event, focusNode) =>
                              focusNode.unfocus(),
                          minHeight: 150,
                          maxHeight: 220,
                        ),
                      ),
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

  /// Theme-aware toolbar buttons: muted when idle, brand-tinted when the
  /// format is active, so the selected state reads in light and dark mode.
  QuillIconTheme _iconTheme(BuildContext context) {
    return QuillIconTheme(
      iconButtonUnselectedData: IconButtonData(
        color: context.secondaryTextColor,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
      iconButtonSelectedData: IconButtonData(
        color: context.brandColor,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(
          backgroundColor: context.brandColor.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
