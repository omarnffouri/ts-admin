import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/app_botton.dart';
import 'package:ts_admin/app/modules/forms/presintation/components/form_appbar.dart';
import 'package:ts_admin/app/modules/forms/presintation/components/form_body.dart';
import 'package:ts_admin/app/modules/forms/presintation/components/signature_section_widget.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/views/components/driver_action_notice_details.dart';
import 'package:ts_admin/app/modules/forms/presintation/form_detail_view/views/components/form_attachment_view.dart';

import '../controllers/form_detail_view_controller.dart';

class FormDetailViewView extends GetView<FormDetailViewController> {
  const FormDetailViewView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDriverActionNotice = controller.form?.formId == 75;

    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: (value) {
          if (value == KeyboardState.visible ||
              value == KeyboardState.visibling) {
            controller.isKeyboardHidden.value = false;
          } else if (value == KeyboardState.hidden ||
              value == KeyboardState.hiding) {
            controller.isKeyboardHidden.value = true;
          }
        },
      ),
      child: Scaffold(
        backgroundColor: isDriverActionNotice
            ? context.backgroundColor
            : AppColorsLight.mainColor,
        body: SafeArea(
          top: !isDriverActionNotice,
          right: !isDriverActionNotice,
          bottom: !isDriverActionNotice,
          left: !isDriverActionNotice,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              color: isDriverActionNotice
                  ? context.backgroundColor
                  : Get.isDarkMode
                      ? Get.theme.scaffoldBackgroundColor
                      : AppColorsLight.white,
              child: Column(
                children: [
                  if (isDriverActionNotice)
                    AppReadHeader(
                      title: 'Form Details',
                      subtitle: controller.form?.formName ?? '',
                      onBack: Get.back,
                    )
                  else
                    //
                    //
                    // header
                    FormAppbar(
                      formName: controller.form!.formName!,
                    ),

                  //
                  //
                  // body
                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: Obx(
                        () =>

                            //
                            // is signing check
                            (controller.isSigning || controller.isRejecting)
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: isDriverActionNotice
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : AppColorsLight.mainColor,
                                    ),
                                  )

                                //
                                //
                                // actual form builder / container
                                : SingleChildScrollView(
                                    padding: isDriverActionNotice
                                        ? const EdgeInsets.fromLTRB(
                                            16,
                                            18,
                                            16,
                                            24,
                                          )
                                        : EdgeInsets.zero,
                                    child: Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: isDriverActionNotice
                                              ? 760
                                              : double.infinity,
                                        ),
                                        child: Column(
                                          children: [
                                            //
                                            // form main bdoy widget
                                            if (isDriverActionNotice)
                                              DriverActionNoticeDetails(
                                                form: controller.form!,
                                              )
                                            else
                                              FormBody(
                                                  formModel: controller.form!),

                                            //
                                            //
                                            if (isDriverActionNotice)
                                              DriverActionNoticeAttachmentsView(
                                                form: controller.form!,
                                              )
                                            else ...[
                                              //
                                              // form videos view
                                              FormAttachmentsView(
                                                form: controller.form!,
                                                attachmentType:
                                                    FormAttachmentType.video,
                                              ),

                                              //
                                              // form attachments
                                              FormAttachmentsView(
                                                form: controller.form!,
                                                attachmentType:
                                                    FormAttachmentType
                                                        .attachment,
                                              ),

                                              //
                                              // other documents
                                              FormAttachmentsView(
                                                form: controller.form!,
                                                attachmentType:
                                                    FormAttachmentType
                                                        .otherDocuments,
                                              ),
                                            ],

                                            SizedBox(
                                              height:
                                                  isDriverActionNotice ? 0 : 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),

                  Obx(
                    () => Visibility(
                      visible: (controller.isKeyboardHidden.value) &&
                          (!controller.isSigning) &&
                          (!controller.isRejecting) &&
                          (!controller.isSigned),
                      child: isDriverActionNotice
                          ? const DriverActionNoticeActionPanel()
                          : Column(
                              children: [
                                //
                                //
                                // signature view

                                SignatureSectionWidget(
                                  controller: controller.signatureController,
                                ).marginSymmetric(horizontal: 20),

                                //
                                //
                                // submit burron
                                Row(
                                  children: [
                                    //
                                    //
                                    // rejection button
                                    Expanded(
                                      child: AppButton(
                                        text: 'Reject',
                                        onTap: () {
                                          controller
                                              .showFormRejectionBottomSheet();
                                        },
                                        isLoading: controller.isRejecting,
                                      ),
                                    ),

                                    //
                                    // spacer
                                    const SizedBox(
                                      width: 20,
                                    ),

                                    //
                                    //
                                    // continue button
                                    Expanded(
                                      child: AppButton(
                                        text: 'Save and Continue',
                                        onTap: () {
                                          controller.saveAndContinue();
                                        },
                                        isLoading: controller.isSigning,
                                      ),
                                    ),
                                  ],
                                ).marginOnly(
                                    left: 20, right: 20, bottom: 10, top: 5),
                              ],
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
}
