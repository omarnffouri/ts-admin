import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../domain/entities/vehicle_details_entity.dart';
import 'vehicle_meta_row.dart';
import 'vehicle_status_badge.dart';

class VehicleDeviceCard extends StatelessWidget {
  const VehicleDeviceCard({
    super.key,
    required this.device,
    required this.isInstalled,
    required this.onUninstall,
  });

  final DeviceData device;
  final bool isInstalled;
  final ValueChanged<String> onUninstall;

  Future<void> _selectUninstallDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.redAccent,
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onUninstall(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  String? _value(String? raw) {
    final String? value = raw?.trim();
    return value == null || value.isEmpty || value == 'null' ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool canUninstall = isInstalled && device.isAssigned == true;

    final String? unitId = _value(device.unitId);
    final String? note = _value(device.deviceNote);
    final String label = isInstalled ? 'Installed' : 'Uninstalled';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // device glyph
          _DeviceGlyph(isInstalled: isInstalled),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // device type
                Text(
                  device.type ?? "",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 8),

                //
                // state + uninstall action
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    VehicleStatusBadge(
                      label: label,
                      tone: isInstalled
                          ? VehicleStatusTone.success
                          : VehicleStatusTone.neutral,
                      icon: isInstalled
                          ? Icons.check_circle_rounded
                          : Icons.link_off_rounded,
                      semanticsLabel: 'Device status: $label',
                    ),
                    if (canUninstall)
                      _UninstallButton(
                        onPressed: () => _selectUninstallDate(context),
                      ),
                  ],
                ),

                //
                // serial / installation details
                VehicleMetaRow(
                  icon: Icons.qr_code_2_rounded,
                  label: "Serial number",
                  value: _value(device.serialNumber),
                ),
                VehicleMetaRow(
                  icon: Icons.event_available_outlined,
                  label: "Installed Date",
                  value: _value(device.installedOn),
                ),
                VehicleMetaRow(
                  icon: Icons.person_outline_rounded,
                  label: "Installed By",
                  value: _value(device.installedBy),
                ),

                if (!isInstalled) ...[
                  VehicleMetaRow(
                    icon: Icons.person_off_outlined,
                    label: "Uninstalled By",
                    value: _value(device.uninstalledBy),
                  ),
                  VehicleMetaRow(
                    icon: Icons.event_busy_outlined,
                    label: "Uninstalled At",
                    value: _value(device.uninstalledOn),
                  ),
                ],

                if (unitId != null)
                  VehicleMetaRow(
                    icon: Icons.tag_rounded,
                    label: "Unit ID",
                    value: unitId,
                  ),
                if (note != null)
                  VehicleMetaRow(
                    icon: Icons.notes_rounded,
                    label: "Note",
                    value: note,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceGlyph extends StatelessWidget {
  const _DeviceGlyph({required this.isInstalled});

  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: Icon(
        isInstalled ? Icons.sensors_rounded : Icons.sensors_off_rounded,
        size: 20,
        color: context.secondaryTextColor,
      ),
    );
  }
}

class _UninstallButton extends StatelessWidget {
  const _UninstallButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.error;

    return Tooltip(
      message: 'Uninstall device',
      child: Semantics(
        button: true,
        label: 'Uninstall device',
        child: ExcludeSemantics(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                constraints: const BoxConstraints(minHeight: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.applyOpacity(context.isDark ? 0.18 : 0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: color.applyOpacity(0.30)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link_off_rounded, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      'Uninstall',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
