import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/dropdown_loading.dart';
import 'package:ts_admin/app/core/widgets/searchable_dropdown.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/shipment_dropdowns_entity.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/controllers/create_shipment_controller.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/components/dropdown_not_available.dart';
import 'package:ts_admin/app/modules/shipment/presentation/create_shipment/views/components/quick_shipment_stepper.dart';

/// General details of a quick shipment: customer, driver, truck & trailer,
/// contracted amount and confirmation file — every step below is rendered by
/// the same [QuickShipmentStepper]/[QuickShipmentStepConfig] pair, only the
/// title, icon and field content change.
class SCGeneralTab extends GetView<CreateShipmentController> {
  const SCGeneralTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Obx(
        () => QuickShipmentStepper(
          steps: _buildSteps(context),
          onStepTapped: (id) => controller.goToGeneralStep(_stepIndex(id)),
        ),
      ),
    );
  }

  int _stepIndex(QuickShipmentStepId id) {
    switch (id) {
      case QuickShipmentStepId.customer:
        return ShipmentCreationGeneralStates.pickCustomer;
      case QuickShipmentStepId.driver:
        return ShipmentCreationGeneralStates.pickDriver;
      case QuickShipmentStepId.truckTrailer:
        return ShipmentCreationGeneralStates.pickTruckTrailer;
      case QuickShipmentStepId.contractedAmount:
        return ShipmentCreationGeneralStates.contarctedAmount;
      case QuickShipmentStepId.confirmationFile:
        return ShipmentCreationGeneralStates.confirmationFile;
    }
  }

  List<QuickShipmentStepConfig> _buildSteps(BuildContext context) {
    return [
      _customerStep(context),
      _driverStep(context),
      _truckTrailerStep(context),
      _contractedAmountStep(context),
      _confirmationFileStep(context),
    ];
  }

  /// Simple current-vs-step comparison shared by every step except
  /// truck/trailer, which has its own disabled/skip rule.
  QuickShipmentStepState _simpleState(int step) {
    final int current = controller.shipmentCreationGeneralState.value;
    final bool hasError = controller.generalStepErrors[step] != null;

    if (step == current) {
      return hasError
          ? QuickShipmentStepState.error
          : QuickShipmentStepState.active;
    }
    if (step < current) {
      return QuickShipmentStepState.completed;
    }
    return QuickShipmentStepState.upcoming;
  }

  QuickShipmentStepState _truckTrailerState() {
    const int step = ShipmentCreationGeneralStates.pickTruckTrailer;
    final int current = controller.shipmentCreationGeneralState.value;
    final bool hasError = controller.generalStepErrors[step] != null;

    if (current == step) {
      return hasError
          ? QuickShipmentStepState.error
          : QuickShipmentStepState.active;
    }
    if ((current > step) && (!controller.isTruckTrailerSelectionDisabled)) {
      return QuickShipmentStepState.completed;
    }
    if (controller.isTruckTrailerSelectionDisabled) {
      return QuickShipmentStepState.disabled;
    }
    return QuickShipmentStepState.upcoming;
  }

  //
  //
  // ─────────────────────────────── Customer ────────────────────────────────
  QuickShipmentStepConfig _customerStep(BuildContext context) {
    const int step = ShipmentCreationGeneralStates.pickCustomer;
    return QuickShipmentStepConfig(
      id: QuickShipmentStepId.customer,
      title: controller.getGeneralStepName(step),
      icon: Icons.person_rounded,
      state: _simpleState(step),
      summary: controller.customerStepSummary,
      errorText: controller.generalStepErrors[step],
      content: StepContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.generalStepErrors[step] != null)
              StepErrorBanner(message: controller.generalStepErrors[step]!),

            //
            // customer selection dropdown
            Obx(
              () => controller.isLoadingDropdownValues
                  ? const DropdownLoadingWidget()
                  : controller.dropdownCustomers.isEmpty
                      ? DropdownNotAvailableWidget(
                          message: "No customers available.",
                          onRetry: controller.getCSDropdownValues,
                        )
                      : SearchableDropDown<CSCustomerDropdownEntity>(
                          list: controller.dropdownCustomers,
                          bottomSheetLabel: 'Select Customer',
                          searchHint: 'search by name',
                          fieldLabel: 'Customer',
                          fieldHint: 'customer',
                          isRequired: true,
                          showOnlyLetters: true,
                          getName: (p0) => p0.name ?? '',
                          getImage: (p0) => p0.name ?? '',
                          selectedItem: controller.selectedCustomer.value,
                          dropdownSearchDecoration:
                              SearchableDropdownDecoration.bordered,
                          dropdownDecoration:
                              SearchableDropdownDecoration.bordered,
                          onItemSelected: (CSCustomerDropdownEntity? item) {
                            if (item != null) {
                              controller.onCustomerSelection(item);
                            }
                          },
                          itemAsString: (item) => item.name ?? "",
                          compareFunction: (item_1, item_2) => item_1 == item_2,
                        ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: controller.customerReferenceController,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration:
                  _fieldDecoration(context, label: "Customer Reference"),
            ),

            const SizedBox(height: 18),
            StepNavigationBar(
              onNext: controller.onGeneralStepNextClicked,
              nextLabel: "Next",
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  // ──────────────────────────────── Driver ─────────────────────────────────
  QuickShipmentStepConfig _driverStep(BuildContext context) {
    const int step = ShipmentCreationGeneralStates.pickDriver;
    return QuickShipmentStepConfig(
      id: QuickShipmentStepId.driver,
      title: controller.getGeneralStepName(step),
      icon: Icons.local_shipping_rounded,
      state: _simpleState(step),
      summary: controller.driverStepSummary,
      errorText: controller.generalStepErrors[step],
      content: StepContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => controller.isLoadingDropdownValues
                  ? const DropdownLoadingWidget()
                  : controller.dropdownDrivers.isEmpty
                      ? DropdownNotAvailableWidget(
                          message: "No drivers available.",
                          onRetry: controller.getCSDropdownValues,
                        )
                      : SearchableDropDown<CSCustomerDropdownEntity>(
                          list: controller.dropdownDrivers,
                          bottomSheetLabel: 'Select Driver',
                          searchHint: 'search by name',
                          fieldLabel: 'Driver',
                          fieldHint: 'driver',
                          isRequired: false,
                          showOnlyLetters: true,
                          getName: (p0) => p0.name ?? '',
                          getImage: (p0) => p0.name ?? '',
                          selectedItem: controller.selectedDriver.value,
                          dropdownSearchDecoration:
                              SearchableDropdownDecoration.bordered,
                          dropdownDecoration:
                              SearchableDropdownDecoration.bordered,
                          onItemSelected: (CSCustomerDropdownEntity? item) {
                            if (item != null) {
                              controller.onDriverSelection(item);
                            }
                          },
                          itemAsString: (item) => item.name ?? "",
                          compareFunction: (item_1, item_2) => item_1 == item_2,
                        ),
            ),
            const SizedBox(height: 18),
            StepNavigationBar(
              onBack: controller.onGeneralStepBackClicked,
              onNext: controller.onGeneralStepNextClicked,
              nextLabel: "Next",
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  // ──────────────────────────── Truck & Trailer ─────────────────────────────
  QuickShipmentStepConfig _truckTrailerStep(BuildContext context) {
    const int step = ShipmentCreationGeneralStates.pickTruckTrailer;
    return QuickShipmentStepConfig(
      id: QuickShipmentStepId.truckTrailer,
      title: controller.getGeneralStepName(step),
      icon: Icons.local_shipping_outlined,
      state: _truckTrailerState(),
      summary: controller.truckTrailerStepSummary,
      errorText: controller.generalStepErrors[step],
      content: StepContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.generalStepErrors[step] != null)
              StepErrorBanner(message: controller.generalStepErrors[step]!),

            //
            // truck selection dropdown
            Obx(
              () => controller.isLoadingDropdownValues
                  ? const DropdownLoadingWidget()
                  : controller.dropdownTrucks.isEmpty
                      ? DropdownNotAvailableWidget(
                          message: "No trucks available.",
                          onRetry: controller.getCSDropdownValues,
                        )
                      : SearchableDropDown<CSTruckDropdownEntity>(
                          list: controller.dropdownTrucks,
                          bottomSheetLabel: 'Select Truck',
                          searchHint: 'search by truck number',
                          fieldLabel: 'Truck',
                          fieldHint: '0000',
                          isRequired: true,
                          showOnlyLetters: true,
                          getName: (p0) => p0.name ?? '',
                          getImage: (p0) => p0.name ?? '',
                          selectedItem: controller.selectedTruck.value,
                          dropdownSearchDecoration:
                              SearchableDropdownDecoration.bordered,
                          dropdownDecoration:
                              SearchableDropdownDecoration.bordered,
                          onItemSelected: (CSTruckDropdownEntity? item) {
                            if (item != null) {
                              controller.onTruckSelection(item);
                            }
                          },
                          itemAsString: (item) => item.name ?? "",
                          compareFunction: (item_1, item_2) => item_1 == item_2,
                        ),
            ),

            const SizedBox(height: 16),

            //
            // trailer type selection dropdown
            Obx(
              () => SearchableDropDown<String>(
                list: TrailerTypes.values,
                bottomSheetLabel: 'Select Trailer Type',
                searchHint: 'search',
                fieldLabel: 'Trailer Type',
                fieldHint: '',
                isRequired: false,
                showOnlyLetters: true,
                getName: (p0) => p0,
                getImage: (p0) => p0,
                selectedItem: controller.selectedTrailerType.value,
                dropdownSearchDecoration: SearchableDropdownDecoration.bordered,
                dropdownDecoration: SearchableDropdownDecoration.bordered,
                onItemSelected: (String? item) {
                  if (item != null) {
                    controller.onTrailerTypeSelection(item);
                  }
                },
              ),
            ),

            //
            // trailer selection dropdown
            Obx(
              () => Visibility(
                visible: controller.selectedTrailerType.value ==
                    TrailerTypes.trailer,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: controller.isLoadingDropdownValues
                      ? const DropdownLoadingWidget()
                      : controller.dropdownTrailers.isEmpty
                          ? DropdownNotAvailableWidget(
                              message: "No trailers available.",
                              onRetry: controller.getCSDropdownValues,
                            )
                          : SearchableDropDown<CSTrailerDropdownEntity>(
                              list: controller.dropdownTrailers,
                              bottomSheetLabel: 'Select Trailer',
                              searchHint: 'search by trailer number',
                              fieldLabel: 'Trailer',
                              fieldHint: '0000',
                              isRequired: true,
                              getName: (p0) => p0.identifier.toString(),
                              selectedItem: controller.selectedTrailer.value,
                              dropdownSearchDecoration:
                                  SearchableDropdownDecoration.bordered,
                              dropdownDecoration:
                                  SearchableDropdownDecoration.bordered,
                              onItemSelected: (CSTrailerDropdownEntity? item) {
                                if (item != null) {
                                  controller.onTrailerSelection(item);
                                }
                              },
                              itemAsString: (item) =>
                                  (item.identifier ?? 0).toString(),
                              compareFunction: (item_1, item_2) =>
                                  item_1 == item_2,
                            ),
                ),
              ),
            ),

            //
            // trailer identifier input
            Obx(
              () => Visibility(
                visible: controller.selectedTrailerType.value ==
                    TrailerTypes.thirdPartyTrailer,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: controller.trailerIndetifierController,
                    keyboardType: TextInputType.number,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: _fieldDecoration(
                      context,
                      label: "Trailer Identifier",
                      isRequired: true,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
            StepNavigationBar(
              onBack: controller.onGeneralStepBackClicked,
              onNext: controller.onGeneralStepNextClicked,
              nextLabel: "Next",
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  // ───────────────────────────── Contracted Amount ──────────────────────────
  QuickShipmentStepConfig _contractedAmountStep(BuildContext context) {
    const int step = ShipmentCreationGeneralStates.contarctedAmount;
    return QuickShipmentStepConfig(
      id: QuickShipmentStepId.contractedAmount,
      title: controller.getGeneralStepName(step),
      icon: Icons.payments_rounded,
      state: _simpleState(step),
      summary: controller.contractedAmountStepSummary,
      errorText: controller.generalStepErrors[step],
      content: StepContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.generalStepErrors[step] != null)
              StepErrorBanner(message: controller.generalStepErrors[step]!),
            TextField(
              controller: controller.contractedAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: _fieldDecoration(
                context,
                label: "Amount",
                isRequired: true,
              ),
            ),
            const SizedBox(height: 18),
            StepNavigationBar(
              onBack: controller.onGeneralStepBackClicked,
              onNext: controller.onGeneralStepNextClicked,
              nextLabel: "Next",
            ),
          ],
        ),
      ),
    );
  }

  //
  //
  // ───────────────────────────── Confirmation File ──────────────────────────
  QuickShipmentStepConfig _confirmationFileStep(BuildContext context) {
    const int step = ShipmentCreationGeneralStates.confirmationFile;
    return QuickShipmentStepConfig(
      id: QuickShipmentStepId.confirmationFile,
      title: controller.getGeneralStepName(step),
      icon: Icons.attach_file_rounded,
      state: _simpleState(step),
      summary: controller.confirmationFileStepSummary,
      errorText: controller.generalStepErrors[step],
      content: StepContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final File? file = controller.confirmationFile.value;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale:
                        Tween<double>(begin: 0.98, end: 1).animate(animation),
                    child: child,
                  ),
                ),
                child: file == null
                    ? _EmptyConfirmationFileZone(
                        key: const ValueKey('empty'),
                        onTap: controller.pickFile,
                      )
                    : _ConfirmationFileCard(
                        key: ValueKey(file.path),
                        file: file,
                      ),
              );
            }),
            const SizedBox(height: 18),
            StepNavigationBar(
              onBack: controller.onGeneralStepBackClicked,
              onNext: controller.onGeneralStepNextClicked,
              nextLabel: "Next",
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    bool isRequired = false,
  }) {
    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.hairlineBorderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: context.focusedBorderColor, width: 1.4),
    );

    return InputDecoration(
      filled: true,
      fillColor: context.fieldFillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      label: RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(context).textTheme.titleSmall,
          children: [
            if (isRequired)
              TextSpan(text: ' *', style: TextStyle(color: context.brandColor)),
          ],
        ),
      ),
      border: idleBorder,
      enabledBorder: idleBorder,
      focusedBorder: focusedBorder,
    );
  }
}

/// Tap target shown when no confirmation file has been picked yet.
class _EmptyConfirmationFileZone extends StatelessWidget {
  const _EmptyConfirmationFileZone({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;

    return Material(
      color: accent.applyOpacity(dark ? 0.07 : 0.04),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: accent.applyOpacity(0.08),
        highlightColor: accent.applyOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: accent.applyOpacity(dark ? 0.45 : 0.35)),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: accent.applyOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cloud_upload_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose confirmation file',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Optional',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.tertiaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.applyOpacity(dark ? 0.18 : 0.12),
                ),
                child: Icon(Icons.add_rounded, size: 20, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact document card shown once a confirmation file is picked: name,
/// type, size when available, a small preview for images, and replace /
/// remove actions.
class _ConfirmationFileCard extends GetView<CreateShipmentController> {
  const _ConfirmationFileCard({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;

    final String ext = controller.getConformationFileExtension();
    final String name = controller.getConformationFileName();

    return Container(
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.panelBorderColor),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: controller.pickFile,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _ConfirmationFileThumbnail(file: file, accent: accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (ext.isNotEmpty) ...[
                            _ExtBadge(ext: ext, accent: accent),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Obx(
                              () {
                                final String? size =
                                    controller.confirmationFileSize.value;
                                return Text(
                                  size == null
                                      ? 'Tap to replace'
                                      : '$size · replace',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: context.tertiaryTextColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RemoveFileButton(onTap: controller.removeConfirmationFile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmationFileThumbnail extends GetView<CreateShipmentController> {
  const _ConfirmationFileThumbnail({required this.file, required this.accent});

  final File file;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (controller.confirmationFileIsImage()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          file,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackIcon(),
        ),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: accent.applyOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(controller.getConformationFileIcon(),
          width: 26, height: 26),
    );
  }
}

class _ExtBadge extends StatelessWidget {
  const _ExtBadge({required this.ext, required this.accent});

  final String ext;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: accent.applyOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        ext.toUpperCase(),
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _RemoveFileButton extends StatelessWidget {
  const _RemoveFileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;
    return Semantics(
      button: true,
      label: 'Remove confirmation file',
      child: Material(
        color: errorColor.applyOpacity(0.10),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(Icons.close_rounded, size: 18, color: errorColor),
          ),
        ),
      ),
    );
  }
}
