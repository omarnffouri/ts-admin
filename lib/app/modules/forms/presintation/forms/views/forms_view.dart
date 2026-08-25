import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/views/tabs/forms_tabs_header.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/views/tabs/pending_forms_tab.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/views/tabs/signed_forms_tab.dart';
import '../controllers/forms_controller.dart';

class FormsView extends GetView<FormsController> {
  const FormsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            //
            // header (title + segmented tabs)
            const FormsTabsHeader(),

            //
            // body
            Expanded(
              child: SafeArea(
                top: false,
                child: _BodyReveal(
                  child: Column(
                    children: [
                      //
                      // search field
                      const _FormsSearchBar(),

                      //
                      // tab content with fade + slide transition
                      Expanded(
                        child: Obx(
                          () {
                            final bool isPending =
                                controller.currentTab == FormsTabs.pending;

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeOutCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.02),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey<bool>(isPending),
                                child: isPending
                                    ? const PendingFormsTab()
                                    : const SignedFormsTab(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

/// Search field styled after the All Users search bar: filled card surface,
/// hairline idle border, and a brand-colored focus ring.
class _FormsSearchBar extends GetView<FormsController> {
  const _FormsSearchBar();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color idleBorderColor = isDark
        ? Colors.white.applyOpacity(0.08)
        : Colors.black.applyOpacity(0.06);

    final idleBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: idleBorderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isDark ? Colors.white.applyOpacity(0.3) : theme.primaryColor,
        width: 1.4,
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: TextField(
        controller: controller.searchTextController,
        maxLines: 1,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.cardColor,
          isDense: true,
          hintText: "Search by name",
          hintStyle: TextStyle(color: theme.hintColor, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          prefixIcon:
              Icon(Icons.search_rounded, size: 20, color: theme.hintColor),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchTextController,
            builder: (context, value, _) {
              return value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        controller.clearSearch();
                      },
                    );
            },
          ),
          border: idleBorder,
          enabledBorder: idleBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }
}

/// One-shot fade + slide reveal for the page content below the header.
class _BodyReveal extends StatelessWidget {
  const _BodyReveal({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
