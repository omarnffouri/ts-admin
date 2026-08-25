import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_loading_wrapper_widget.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../../../../domain/entities/service_order_entity.dart';
import '../controllers/create_edit_service_order_controller.dart';
import 'buttom_sheets/customer_details_buttom_sheet.dart';
import 'components/category_dropdown_widget.dart';
import 'components/client_dropdown_widget.dart';
import 'components/completion_date_picker_widget.dart';
import 'components/customer_complaint_widget.dart';
import 'components/date_picker_widget.dart';
import 'components/model_type_dropdown_widget.dart';
import 'components/unit_dropdown_widget.dart';
import 'components/technicians_dropdown_widget.dart';
import 'sections/animated_service_details_widget.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class CreateEditServiceOrderView
    extends GetView<CreateEditServiceOrderController> {
  const CreateEditServiceOrderView({super.key});
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
            const _Header(),
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
                    slivers: [ServiceOrderBody()],
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

class _Header extends GetView<CreateEditServiceOrderController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double topInset = MediaQuery.paddingOf(context).top;

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(16, topInset + 10, 16, 16),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: Get.back,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => Text(
                controller.isUpdating.value
                    ? "Edit Service Order #${controller.serviceOrderEntity.value?.id ?? 0}"
                    : "Create Service Order",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceOrderBody extends GetView<CreateEditServiceOrderController> {
  const ServiceOrderBody({super.key});

  // Method to show a modal bottom sheet
  void _showCustomerDetails() {
    final controller = Get.find<CreateEditServiceOrderController>();
    Get.bottomSheet(
      Container(
        width: Get.width,
        constraints: BoxConstraints(
          minHeight: Get.height * 0.7,
          maxHeight: Get.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColorsDark.scaffoldBackroundColor
              : AppColorsLight.scaffoldBackroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          border: Border.all(
            color: Colors.grey,
            width: .5,
          ),
        ),
        child: FutureBuilder<CustomerEntity>(
          future: controller.getCustomerDetails(),
          builder:
              (BuildContext context, AsyncSnapshot<CustomerEntity> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColorsLight.mainColor,
              ));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Failed to load customer details. Please try again.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              final customer = snapshot.data!;
              return CustomerDetailsButtomSheet(customer: customer);
            } else {
              return const Center(
                  child: Text('No customer details available.'));
            }
          },
        ),
      ),
    );
  }

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
                  _SectionEntrance(
                    child: _SectionCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Order Information',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                      controller:
                                          controller.orderNumberController,
                                      borderColor: context.hairlineBorderColor,
                                      borderRadius: 12,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => DatePickerWidget(
                                    isEnabled: controller.isEditEnabled.value,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: CompletionDatePickerWidget(),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CategoryDropdownWidget(
                              isEnabled: controller.isEditEnabled.value,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => ClientDropdownWidet(
                              isEnabled: controller.isEditEnabled.value,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => ModelTypeDropdownWidget(
                              isEnabled: controller.isEditEnabled.value,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => UnitDropdownWidet(
                              isEnabled: controller.isEditEnabled.value,
                            ),
                          ),
                          Obx(
                            () => AnimatedSize(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              alignment: Alignment.topLeft,
                              child: controller.showCustomerDetails
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _showCustomerDetails,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 9,
                                              ),
                                              decoration: BoxDecoration(
                                                color: context.brandColor
                                                    .applyOpacity(0.08),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: context.brandColor
                                                      .applyOpacity(0.18),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    size: 18,
                                                    color: context.brandColor,
                                                  ),
                                                  const SizedBox(width: 7),
                                                  Text(
                                                    "View customer details",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: context
                                                              .brandColor,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    Icons.chevron_right_rounded,
                                                    size: 18,
                                                    color: context.brandColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionEntrance(
                    child: _SectionCard(
                      icon: Icons.format_align_left_rounded,
                      title: 'Customer Complaint',
                      child: CustomerComplaintWidget(
                        isEnabled: controller.isEditEnabled,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SectionEntrance(
                    child: ServiceDetailsSection(),
                  ),
                  const SizedBox(height: 16),
                  _SectionEntrance(
                    child: _SectionCard(
                      icon: Icons.engineering_outlined,
                      title: 'Assignment',
                      child: Obx(
                        () => TechniciansDropdownWidget(
                          isEnabled: controller.isEditEnabled.value,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SectionEntrance(
                    child: Obx(
                      () => MainAppButton(
                        label: controller.isUpdating.value
                            ? "Update Service Order"
                            : "Create Service Order",
                        height: 52,
                        borderRadius: 14,
                        isLoading: controller.isSubmitting.value,
                        leadingIcon: const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller.isSubmitting.value) return;
                          controller.submitServiceOrder();
                        },
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

class ServiceDetailsSection extends GetView<CreateEditServiceOrderController> {
  const ServiceDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.home_repair_service_outlined,
      title: 'Service Details',
      action: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            controller.addServiceDetailsField();
            controller.serviceDetailsKey.currentState?.insertItem(
              0,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: context.brandColor.applyOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.brandColor.applyOpacity(0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 18, color: context.brandColor),

                // Text(
                //   'Add service',
                //   style: Theme.of(context).textTheme.labelLarge?.copyWith(
                //         color: context.brandColor,
                //         fontWeight: FontWeight.w700,
                //       ),
                // ),
              ],
            ),
          ),
        ),
      ),
      child: AnimatedServiceDetailsWidget(
        animatedListKey: controller.serviceDetailsKey,
        serviceDetails: controller.serviceDetails,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.045),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.brandColor.applyOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 19, color: context.brandColor),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 10),
                action!,
              ],
            ],
          ),
          const SizedBox(height: 18),
          Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                filled: true,
                fillColor: context.fieldFillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.hairlineBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.hairlineBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: context.focusedBorderColor,
                    width: 1.4,
                  ),
                ),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

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
