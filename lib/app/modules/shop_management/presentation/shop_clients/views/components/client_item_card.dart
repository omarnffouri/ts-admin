import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/clipboard_helper.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import '../../../../domain/entities/client_entity.dart';
import '../../controllers/shop_clients_controller.dart';
import 'client_buttom_sheet.dart';

class ClientCard extends GetView<ShopClientsController> {
  final ClientEntity client;

  const ClientCard({super.key, required this.client});

  static const double _radius = 18;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isActive = client.isActive == true;
    final String name = client.companyName?.trim() ?? '';
    final bool hasContactPerson =
        (client.contactPerson?.trim().isNotEmpty ?? false);
    final bool hasContactNumber =
        (client.contactNumber?.trim().isNotEmpty ?? false);
    final bool hasEmail = (client.email?.trim().isNotEmpty ?? false);

    return Slidable(
      key: ValueKey(client.id),
      closeOnScroll: true,
      groupTag: 'client_listing_slide_group',
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => controller.onDisableClientCicked(client),
            backgroundColor: context.brandColor,
            foregroundColor: Colors.white,
            icon: isActive ? Icons.person_off_outlined : Icons.person_outline,
            label: isActive ? 'Disable'.tr : 'Enable'.tr,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_radius),
              bottomLeft: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
          SlidableAction(
            onPressed: (_) {
              final arg = {
                'client': client,
                'isUsedPart': controller.isUsedPart.value,
              };
              Get.toNamed(Routes.CREATE_EDIT_CLIENT, arguments: arg);
            },
            backgroundColor: context.primaryTextColor,
            foregroundColor: context.backgroundColor,
            icon: Icons.edit_outlined,
            label: 'Update'.tr,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
            ),
            padding: const EdgeInsets.all(2),
          ),
        ],
      ),
      child: Semantics(
        button: true,
        label: name.isEmpty ? 'View client details' : 'View details for $name',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_radius),
            onTap: () => _showClientDetails(context, client),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.tileColor,
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: context.isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.applyOpacity(0.045),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ClientAvatar(name: name),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'No Name Provided'.tr : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: context.primaryTextColor,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ClientStatusBadge(isActive: isActive),
                    ],
                  ),
                  if (hasContactPerson || hasContactNumber || hasEmail) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: context.hairlineBorderColor),
                    const SizedBox(height: 10),
                  ],
                  if (hasContactPerson)
                    _ClientContactRow(
                      icon: Icons.person_outline_rounded,
                      text: client.contactPerson!.trim(),
                      copyMessage: 'Contact person copied successfully.',
                    ),
                  if (hasContactNumber)
                    Padding(
                      padding: EdgeInsets.only(top: hasContactPerson ? 6 : 0),
                      child: _ClientContactRow(
                        icon: Icons.phone_outlined,
                        text: client.contactNumber!.trim(),
                        copyMessage: 'Contact number copied successfully.',
                      ),
                    ),
                  if (hasEmail)
                    Padding(
                      padding: EdgeInsets.only(
                        top: hasContactPerson || hasContactNumber ? 6 : 0,
                      ),
                      child: _ClientContactRow(
                        icon: Icons.email_outlined,
                        text: client.email!.trim(),
                        copyMessage: 'Email copied successfully.',
                      ),
                    ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: context.tertiaryTextColor,
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

/// Initials avatar with a polished tinted fill; falls back to a business
/// icon when the client has no usable company name.
class _ClientAvatar extends StatelessWidget {
  const _ClientAvatar({required this.name});

  final String name;

  static const double _size = 44;

  String get _initials {
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String initials = _initials;

    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.brandColor.applyOpacity(context.isDark ? 0.18 : 0.10),
        border: Border.all(color: context.brandColor.applyOpacity(0.24)),
      ),
      child: initials.isEmpty
          ? Icon(
              Icons.business_rounded,
              size: 20,
              color: context.isDark
                  ? Colors.white.applyOpacity(0.85)
                  : context.brandColor,
            )
          : Text(
              initials,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: context.isDark
                        ? Colors.white.applyOpacity(0.9)
                        : context.brandColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
    );
  }
}

class _ClientStatusBadge extends StatelessWidget {
  const _ClientStatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isActive
        ? (context.isDark ? Colors.green.shade300 : Colors.green.shade700)
        : Theme.of(context).colorScheme.error;
    final String label = isActive ? 'Active'.tr : 'Inactive'.tr;

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: foreground.applyOpacity(context.isDark ? 0.30 : 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: foreground.applyOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration:
                  BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single contact line (contact person / phone / email). Tapping copies
/// the value to the clipboard, matching the tap-to-copy pattern used for
/// contact details elsewhere in the app (see ApplicationsView).
class _ClientContactRow extends StatelessWidget {
  const _ClientContactRow({
    required this.icon,
    required this.text,
    required this.copyMessage,
  });

  final IconData icon;
  final String text;
  final String copyMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: context.tertiaryTextColor)
            .marginOnly(right: 6, top: 2),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  try {
                    ClipboardHelper.copyPlainText(
                      text,
                      showSnackBar: true,
                      message: copyMessage,
                    );
                  } catch (_) {}
                },
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

// Method to show a modal bottom sheet with the full client details
// (address and tax number aren't shown on the card).
void _showClientDetails(BuildContext context, ClientEntity client) {
  Get.bottomSheet(
    Container(
      width: Get.width,
      constraints: BoxConstraints(
        minHeight: Get.height * 0.3,
        maxHeight: Get.height * 0.4,
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
      child: ClientButtomSheet(client: client),
    ),
  );
}
