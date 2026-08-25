import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/core/widgets/app_read_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../controllers/create_edit_purchased_order_controller.dart';
import 'components/client_dropdown_widget.dart';
import 'components/date_picker_widget.dart';
import 'components/purchase_order_description_editor.dart';
import 'components/purchase_order_form_section.dart';
import 'components/purchase_order_form_summary.dart';
import 'components/purchase_order_parts_section.dart';

class CreateEditPurchasedOrderView
    extends GetView<CreateEditPurchasedOrderController> {
  const CreateEditPurchasedOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            //
            // header
            const _Header(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: SmartRefresher(
                  controller: controller.refreshController,
                  header: const WaterDropMaterialHeader(),
                  onRefresh: controller.handleRefresh,
                  child: const CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [PurchaseOrderFormBody()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends GetView<CreateEditPurchasedOrderController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isUpdating = controller.isUpdating.value;
        final String orderId =
            '${controller.purchaseOrderEntity.value?.id ?? 0}';

        return AppReadHeader(
          title: isUpdating ? 'Edit Purchase Order' : 'Create Purchase Order',
          subtitle: isUpdating ? 'Order #$orderId' : 'New purchase order',
          subtitleSemanticsLabel: isUpdating
              ? 'Editing purchase order number $orderId'
              : 'New purchase order',
          onBack: Get.back,
        );
      },
    );
  }
}

class PurchaseOrderFormBody
    extends GetView<CreateEditPurchasedOrderController> {
  const PurchaseOrderFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //
                  // order information
                  const _SectionEntrance(child: _OrderInformationSection()),
                  const SizedBox(height: 16),

                  //
                  // description
                  _SectionEntrance(
                    child: PurchaseOrderFormSection(
                      icon: Icons.notes_rounded,
                      title: 'Description',
                      child: PurchaseOrderDescriptionEditor(
                        isEnabled: controller.isEditEnabled,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //
                  // vehicle parts
                  const _SectionEntrance(child: PurchaseOrderPartsSection()),
                  const SizedBox(height: 16),

                  //
                  // summary
                  const _SectionEntrance(child: PurchaseOrderFormSummary()),
                  const SizedBox(height: 22),

                  //
                  // create / update action
                  const _SectionEntrance(child: _SubmitButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderInformationSection
    extends GetView<CreateEditPurchasedOrderController> {
  const _OrderInformationSection();

  @override
  Widget build(BuildContext context) {
    return PurchaseOrderFormSection(
      icon: Icons.receipt_long_outlined,
      title: 'Order Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
          // order number (read-only, existing orders only)
          Obx(
            () => Visibility(
              visible: controller.isUpdating.value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Opacity(
                  opacity: .6,
                  child: LoadingWrapperWidget(
                    isLoading: controller.isLoading.value,
                    child: RoundedInputField(
                      hintText: "",
                      label: "Order Number",
                      isRequired: false,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: controller.orderNumberController,
                      borderColor: context.hairlineBorderColor,
                      borderRadius: 12,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //
          // service date
          Obx(
            () => DatePickerWidget(
              isEnabled: controller.isEditEnabled.value,
            ),
          ),
          const SizedBox(height: 16),

          //
          // client
          Obx(
            () => ClientDropdownWidet(
              isEnabled: controller.isEditEnabled.value,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends GetView<CreateEditPurchasedOrderController> {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isUpdating = controller.isUpdating.value;
        final bool isSubmitting = controller.isSubmitting.value;

        return MainAppButton(
          label: isUpdating ? "Update Purchase Order" : "Create Purchase Order",
          height: 52,
          borderRadius: 14,
          isLoading: isSubmitting,
          leadingIcon: const Icon(
            Icons.check_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            if (controller.isSubmitting.value) return;
            controller.submitServiceOrder();
          },
        );
      },
    );
  }
}

/// One-shot fade + slide reveal for each section, skipped when the platform
/// asks for reduced motion.
class _SectionEntrance extends StatelessWidget {
  const _SectionEntrance({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
