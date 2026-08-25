import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/routes/app_pages.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

class ShopManagement extends StatefulWidget {
  const ShopManagement({super.key});

  @override
  State<ShopManagement> createState() => _ShopManagementState();
}

class _ShopManagementState extends State<ShopManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const _Header(
            title: "Shop Management",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ButtonCard(
                      text: "Service Orders",
                      imagePath: Assets.icons.orders,
                      onTap: () {
                        Get.toNamed(Routes.SERVICE_ORDERS);
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Shop Inventories",
                      imagePath: Assets.icons.shopInventories,
                      onTap: () {
                        Get.to(() => const ShopInventory());
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Used Parts",
                      imagePath: Assets.icons.shopInventories,
                      onTap: () {
                        Get.to(() => const UsedParts());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double topInset = MediaQuery.of(context).padding.top;

    return AppRedHeader(
      width: double.infinity,
      radius: 32,
      padding: EdgeInsets.fromLTRB(12, topInset + 12, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onTap;

  const ButtonCard({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.applyOpacity(0.08)
              : const Color(0xFFEDEDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.applyOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // red-tinted icon container
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColorsLight.mainColor.applyOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SvgPicture.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      AppColorsLight.mainColor.applyOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // title
                Expanded(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // arrow chip
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColorsLight.calanderBoxColor.applyOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: isDark
                        ? Colors.white.applyOpacity(0.8)
                        : Colors.black.applyOpacity(0.4),
                    size: 18,
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

class ShopInventory extends StatelessWidget {
  const ShopInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const _Header(
            title: "Shop Inventories",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ButtonCard(
                      text: "Inventories",
                      imagePath: Assets.icons.shopInventories,
                      onTap: () {
                        Get.toNamed(Routes.SHOP_INVENTORIES);
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Suppliers",
                      imagePath: Assets.icons.suppliersManagement,
                      onTap: () {
                        Get.toNamed(Routes.SHOP_SUPPLIERS);
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Clients",
                      imagePath: Assets.icons.clientsManagement,
                      onTap: () {
                        Get.toNamed(Routes.SHOP_CLIENTS);
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Technicians",
                      imagePath: Assets.icons.technician,
                      onTap: () {
                        Get.toNamed(Routes.TECHNICIANS);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UsedParts extends StatelessWidget {
  const UsedParts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const _Header(
            title: "Used Parts",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ButtonCard(
                      text: "Inventories",
                      imagePath: Assets.icons.shopInventories,
                      onTap: () {
                        const isUsedParts = true;
                        Get.toNamed(
                          Routes.SHOP_INVENTORIES,
                          arguments: isUsedParts,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Suppliers",
                      imagePath: Assets.icons.suppliersManagement,
                      onTap: () {
                        const isUsedParts = true;
                        Get.toNamed(
                          Routes.SHOP_SUPPLIERS,
                          arguments: isUsedParts,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Clients",
                      imagePath: Assets.icons.clientsManagement,
                      onTap: () {
                        const isUsedParts = true;
                        Get.toNamed(
                          Routes.SHOP_CLIENTS,
                          arguments: isUsedParts,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonCard(
                      text: "Purchased Orders",
                      imagePath: Assets.icons.orders,
                      onTap: () {
                        Get.toNamed(Routes.PURCHASED_ORDERS);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
