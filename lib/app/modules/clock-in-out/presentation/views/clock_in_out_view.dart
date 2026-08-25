import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/controllers/clock_in_out_controller.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_hero_card.dart';
import 'package:ts_admin/app/modules/clock-in-out/presentation/views/components/dashboard/dashboard_scroll.dart';
import 'package:ts_admin/app/routes/app_pages.dart';

import 'components/home_tabs_header.dart';
import 'tabs/annoucments_tab.dart';
import 'tabs/forms_tabs.dart';

class ClockInOutView extends GetView<ClockInOutController> {
  const ClockInOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final theme = Theme.of(context);
    Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SmartRefresher(
        controller: controller.bodyRefeshController,
        // Snaps the hero to fully open / fully collapsed on release — the
        // ballistic simulation never settles inside the collapse zone.
        physics: const HeroSnapScrollPhysics(),
        // Front-style indicator: it paints over the pinned hero instead of
        // displacing it, so it needs an offset to clear the status bar and
        // white-on-red colours to stay legible against the header.
        header: WaterDropMaterialHeader(
          color: context.brandColor,
          backgroundColor: Colors.white,
          offset: topInset + 8,
        ),
        onRefresh: controller.handleDashboardRefresh,
        child: CustomScrollView(
          slivers: [
            DashboardHeroSliver(topInset: topInset),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _InvoicePaymentBanner(),
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: context.tileColor,
                        border: Border.all(color: context.hairlineBorderColor),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: context.cardShadow,
                      ),
                      child: Column(
                        children: [
                          const HomeTabHeader(),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            child: Obx(
                              () => controller.currentTab.value ==
                                      HomeTabs.annoucments
                                  ? const AnnoucmentsTab()
                                  : const FormsTab(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ]),
              ),
            ),
            const DashboardCollapseSpacer(),
          ],
        ),
      ),
    );
  }
}

class _InvoicePaymentBanner extends GetView<ClockInOutController> {
  const _InvoicePaymentBanner();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.invoicePayments.isEmpty) return const SizedBox.shrink();
      final invoice = controller.invoicePayments.first;

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColorsLight.mainColorDark,
              AppColorsLight.mainColorLight
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: context.accentGlow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "New payment request to review",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.invoicePayments.clear,
                  child: Icon(Icons.close_rounded,
                      color: Colors.white.applyOpacity(0.85), size: 20),
                ),
              ],
            ),
            if ((invoice.invoiceNumber ?? "").isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                invoice.invoiceNumber!,
                style: TextStyle(
                  color: Colors.white.applyOpacity(0.9),
                  fontSize: 12.5,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BannerAction(
                    label: "Reject",
                    filled: true,
                    onTap: () {
                      controller.invoicePayments.clear();
                      Get.toNamed(Routes.INVOICE_PAYMENT_REQUESTS);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BannerAction(
                    label: "Review",
                    filled: false,
                    onTap: () {
                      controller.invoicePayments.clear();
                      Get.toNamed(Routes.INVOICE_PAYMENT_REQUESTS);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: filled ? null : Border.all(color: Colors.white),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? context.brandColor : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
