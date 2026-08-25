import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

class VehicleSectionCard extends StatelessWidget {
  const VehicleSectionCard({super.key, required this.child});

  final Widget child;

  static const double radius = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: context.hairlineBorderColor),
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
      child: child,
    );
  }
}

/// Soft brand medallion used as the leading glyph of a section heading.
class VehicleSectionMedallion extends StatelessWidget {
  const VehicleSectionMedallion({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.brandColor.applyOpacity(isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: context.brandColor.applyOpacity(0.22)),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isDark ? Colors.white.applyOpacity(0.9) : context.brandColor,
      ),
    );
  }
}

/// Section heading: medallion + title, an optional item count and an optional
/// trailing action (e.g. Notes → add note).
class VehicleSectionHeader extends StatelessWidget {
  const VehicleSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.count,
    this.action,
    this.padding = const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
  });

  final IconData icon;
  final String title;
  final int? count;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          //
          // leading glyph
          VehicleSectionMedallion(icon: icon),

          const SizedBox(width: 10),

          //
          // title
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          //
          // item count
          if (count != null) ...[
            const SizedBox(width: 8),
            _CountBadge(count: count!),
          ],

          //
          // section action
          if (action != null) ...[
            const SizedBox(width: 6),
            action!,
          ],
        ],
      ),
    );
  }
}

class VehicleSection extends StatelessWidget {
  const VehicleSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.count,
    this.action,
    this.bodyPadding = const EdgeInsets.all(12),
  });

  final IconData icon;
  final String title;
  final Widget child;
  final int? count;
  final Widget? action;
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: title,
      child: VehicleSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VehicleSectionHeader(
              icon: icon,
              title: title,
              count: count,
              action: action,
            ),
            Divider(height: 1, color: context.hairlineBorderColor),
            Padding(padding: bodyPadding, child: child),
          ],
        ),
      ),
    );
  }
}

class VehicleSectionAction extends StatelessWidget {
  const VehicleSectionAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: TextButton.styleFrom(
        foregroundColor: context.isDark
            ? Colors.white.applyOpacity(0.92)
            : context.brandColor,
        backgroundColor:
            context.brandColor.applyOpacity(context.isDark ? 0.16 : 0.08),
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: BorderSide(color: context.brandColor.applyOpacity(0.24)),
        ),
      ),
    );
  }
}

class VehicleSectionIconAction extends StatelessWidget {
  const VehicleSectionIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: 18,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 38, height: 38),
      style: IconButton.styleFrom(
        backgroundColor:
            context.brandColor.applyOpacity(context.isDark ? 0.16 : 0.08),
        foregroundColor: context.isDark
            ? Colors.white.applyOpacity(0.9)
            : context.brandColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: BorderSide(color: context.brandColor.applyOpacity(0.24)),
        ),
      ),
      icon: Icon(icon, semanticLabel: tooltip),
    );
  }
}

/// Refresh-progress bar + SmartRefresher + CustomScrollView for a vehicle
/// details tab. `sliver` is the tab's single content sliver (error or body).
class VehicleDetailsTabView extends StatelessWidget {
  const VehicleDetailsTabView({
    super.key,
    required this.isLoading,
    required this.refreshLabel,
    required this.refreshController,
    required this.onRefresh,
    required this.sliver,
    this.slidableAutoClose = false,
  });

  final bool isLoading;
  final String refreshLabel;
  final RefreshController refreshController;
  final Future<void> Function() onRefresh;
  final Widget sliver;
  final bool slidableAutoClose;

  @override
  Widget build(BuildContext context) {
    Widget refresher = SmartRefresher(
      controller: refreshController,
      header: const WaterDropMaterialHeader(),
      onRefresh: () async {
        await onRefresh();
        refreshController.refreshCompleted();
      },
      child: CustomScrollView(slivers: [sliver]),
    );
    if (slidableAutoClose) {
      refresher = SlidableAutoCloseBehavior(child: refresher);
    }

    return Column(
      children: [
        if (isLoading)
          LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: Colors.transparent,
            color: context.brandColor,
            semanticsLabel: refreshLabel,
          ),
        Expanded(child: refresher),
      ],
    );
  }
}

class VehicleDetailsLoadingView extends StatelessWidget {
  const VehicleDetailsLoadingView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Shimmer.fromColors(
        baseColor: context.isDark ? Colors.white10 : Colors.black12,
        highlightColor: context.isDark ? Colors.white24 : Colors.white30,
        child: child,
      ),
    );
  }
}

class VehicleSectionSkeleton extends StatelessWidget {
  const VehicleSectionSkeleton({
    super.key,
    required this.icon,
    required this.title,
    required this.itemHeight,
    this.itemCount = 2,
  });

  final IconData icon;
  final String title;
  final double itemHeight;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return VehicleSection(
      icon: icon,
      title: title,
      child: Column(
        spacing: 10,
        children: List.generate(
          itemCount,
          (_) => Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: context.surfaceVariantColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$count ${count == 1 ? 'item' : 'items'}',
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minWidth: 26),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: context.hairlineBorderColor),
        ),
        child: Text(
          '$count',
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.secondaryTextColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
