import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/core/widgets/app_red_header.dart';

class VehicleDetailsLayout extends StatelessWidget {
  const VehicleDetailsLayout({
    super.key,
    required this.header,
    required this.titles,
    required this.pages,
  });

  final Widget header;
  final List<String> titles;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          header,
          Expanded(
            child: SafeArea(
              top: false,
              child: DefaultTabController(
                length: titles.length,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _PagesTabBar(titles: titles),
                    const SizedBox(height: 4),
                    Expanded(child: TabBarView(children: pages)),
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

class VehicleDetailsHeader extends StatelessWidget {
  const VehicleDetailsHeader({
    super.key,
    required this.title,
    required this.identifier,
    required this.identifierLabel,
    required this.onBack,
  });

  final String title;
  final String? identifier;
  final String identifierLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppRedHeader(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.paddingOf(context).top + 10.h,
        16.w,
        16.h,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: Colors.white.applyOpacity(0.16),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.applyOpacity(0.22),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Colors.white,
                  semanticLabel: 'Back',
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                ),
                if (identifier != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _IdentifierBadge(
                      identifier: identifier!,
                      label: identifierLabel,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentifierBadge extends StatelessWidget {
  const _IdentifierBadge({required this.identifier, required this.label});

  final String identifier;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label identifier: $identifier',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.applyOpacity(0.16),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.applyOpacity(0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tag_rounded,
              size: 13,
              color: Colors.white.applyOpacity(0.85),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                identifier,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PagesTabBar extends StatelessWidget {
  const _PagesTabBar({required this.titles});

  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        (Theme.of(context).textTheme.labelLarge ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceColor.applyOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.hairlineBorderColor),
      ),
      child: TabBar(
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: context.tabButton,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: context.tabButton.applyOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        splashBorderRadius: BorderRadius.circular(10),
        labelColor: Colors.white,
        unselectedLabelColor: context.secondaryTextColor,
        labelStyle: labelStyle,
        unselectedLabelStyle: labelStyle.copyWith(fontWeight: FontWeight.w600),
        tabs: titles
            .map(
              (title) => Tab(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(title, maxLines: 1),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
