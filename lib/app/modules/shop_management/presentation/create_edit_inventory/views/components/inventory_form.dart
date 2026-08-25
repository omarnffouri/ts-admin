import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';
import 'package:ts_admin/app/core/widgets/rounded_input_field.dart';

import '../../controllers/create_edit_inventory_controller.dart';
import 'supplier_dropdown_widget.dart';

class InventoryForm extends GetView<CreateEditInventoryController> {
  const InventoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
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
                    icon: Icons.inventory_2_outlined,
                    title: 'Item Information',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SupplierDropdownWidet(),
                        const SizedBox(height: 16),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: RoundedInputField(
                                hintText: 'Enter item number',
                                label: 'Item Number',
                                isRequired: true,
                                keyboardType: TextInputType.number,
                                controller: controller.itemNumberController,
                                borderColor: context.hairlineBorderColor,
                                borderRadius: 12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "item number is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              child: RoundedInputField(
                                hintText: 'Enter item name',
                                label: 'Item Name',
                                isRequired: true,
                                controller: controller.itemNameController,
                                borderColor: context.hairlineBorderColor,
                                borderRadius: 12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Item Name is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 16),

                        const SizedBox(height: 16),
                        RoundedInputField(
                          hintText: 'Enter quantity',
                          label: 'Quantity',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          controller: controller.quantityController,
                          borderColor: context.hairlineBorderColor,
                          borderRadius: 12,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Quantity is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionEntrance(
                  child: _SectionCard(
                    icon: Icons.payments_outlined,
                    title: 'Pricing',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Expanded(
                              child: RoundedInputField(
                                hintText: '0.00',
                                label: 'Buying Price',
                                isRequired: true,
                                keyboardType: TextInputType.number,
                                controller: controller.buyPriceController,
                                borderColor: context.hairlineBorderColor,
                                borderRadius: 12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Buying Price is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              child: RoundedInputField(
                                hintText: '0',
                                label: 'Tax (%)',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                controller: controller.taxController,
                                borderColor: context.hairlineBorderColor,
                                borderRadius: 12,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Tax is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        RoundedInputField(
                          hintText: '0',
                          label: 'Markup Price (%)',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          controller: controller.markupPriceController,
                          borderColor: context.hairlineBorderColor,
                          borderRadius: 12,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return "Markup Price is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Opacity(
                          opacity: 0.65,
                          child: RoundedInputField(
                            hintText: '0.00',
                            label: 'Selling Price',
                            isRequired: true,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            controller: controller.sellPriceController,
                            borderColor: context.hairlineBorderColor,
                            borderRadius: 12,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: 18,
                              color: context.tertiaryTextColor,
                            ),
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Selling Price is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 14,
                              color: context.tertiaryTextColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Calculated automatically from buying price, tax and markup'
                                    .tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: context.tertiaryTextColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _TotalSummaryCard(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _SectionEntrance(
                  child: Obx(
                    () => MainAppButton(
                      label: controller.isUpdating.value
                          ? 'Update Inventory'.tr
                          : 'Create Inventory'.tr,
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
                        controller.createOrEditInventory();
                      },
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

class _TotalSummaryCard extends GetView<CreateEditInventoryController> {
  const _TotalSummaryCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: context.brandColor.applyOpacity(context.isDark ? 0.10 : 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.brandColor.applyOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.brandColor.applyOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.calculate_outlined,
              size: 19,
              color: context.brandColor,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total'.tr,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Quantity × buying price, incl. tax'.tr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.tertiaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => Text(
              '\$${num.parse(controller.total.value).toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.brandColor,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
                  title.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
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
