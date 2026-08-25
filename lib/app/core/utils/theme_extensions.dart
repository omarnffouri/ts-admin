import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/resources/themes/dark/dark_colors.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Semantic theme colors and elevation resolved from the active brightness, so
/// widgets can write `context.surfaceColor` instead of repeating
/// `isDark ? AppColorsDark.x : AppColorsLight.x` ternaries.
///
/// Colors that must stay light regardless of the app theme — anything painted
/// on the red [AppRedHeader] gradient — do NOT belong here. Those are raw
/// constants: `AppColorsLight.onHero*`.
extension ContextColorExtensions on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Brand red — identical in both modes (matches the AppRedHeader accents).
  Color get brandColor => AppColorsLight.mainColor;

  /// Floating-action-button
  Color get floatingButtonColor =>
      isDark ? const Color.fromARGB(255, 135, 12, 4) : brandColor;

  Color get tabButton =>
      isDark ? const Color.fromARGB(255, 128, 13, 4) : brandColor;

  //
  // surfaces
  Color get backgroundColor => isDark
      ? AppColorsDark.scaffoldBackroundColor
      : AppColorsLight.scaffoldBackroundColor;

  /// Card-surface color.
  Color get surfaceColor => isDark
      ? AppColorsDark.cardBackgroundColor
      : AppColorsLight.cardBackgroundColor;

  /// Translucent card fill for input fields (title, editor, dropdowns).
  Color get fieldFillColor => surfaceColor.applyOpacity(0.3);

  /// Elevated tile fill for list/attachment cards.
  Color get tileColor => isDark ? const Color(0xFF1C1C1C) : Colors.white;

  /// Subtle tint for grouped strips (e.g. the editor toolbar).
  Color get surfaceVariantColor => isDark
      ? Colors.white.applyOpacity(0.04)
      : Colors.black.applyOpacity(0.03);

  /// Translucent flat list-card fill (request cards and their skeletons) —
  /// softer than [tileColor]'s opaque fill.
  Color get flatCardColor =>
      isDark ? Colors.white.applyOpacity(0.045) : Colors.white;

  /// Neutral fill for secondary controls (muted buttons, sheet close).
  /// Slightly stronger in light mode — 5% dissolves into white cards.
  Color get mutedControlColor => isDark
      ? Colors.white.applyOpacity(0.08)
      : Colors.black.applyOpacity(0.07);

  //
  // borders
  /// Idle border for card-surface fields.
  Color get hairlineBorderColor =>
      isDark ? Colors.white.applyOpacity(0.08) : Colors.grey.applyOpacity(0.2);

  /// More visible border for elevated tiles/cards.
  Color get panelBorderColor => isDark ? Colors.white24 : Colors.grey.shade300;

  /// Focus ring for card-surface fields.
  Color get focusedBorderColor =>
      isDark ? Colors.white.applyOpacity(0.3) : AppColorsLight.mainColor;

  //
  // semantic status
  /// Positive result — the green the clock-in action already uses.
  Color get successColor => isDark
      ? AppColorsDark.clockInButtonColor
      : AppColorsLight.clockInButtonColor;

  /// Negative result — the theme's error color.
  Color get dangerColor => Theme.of(this).colorScheme.error;

  /// Money amounts that must pop — brand red, brightened in dark mode.
  Color get amountAccentColor =>
      isDark ? AppColorsDark.amountAccentColor : AppColorsLight.mainColor;

  //
  // text
  Color get primaryTextColor =>
      isDark ? AppColorsDark.textColor : AppColorsLight.textColor;

  /// Muted labels (section headings, icons next to them).
  Color get secondaryTextColor =>
      isDark ? Colors.white60 : Colors.black.applyOpacity(0.55);

  /// Muted metadata lines derived from the body text color. Light mode gets
  /// 0.7 — 0.6 gray on white sits below AA for the small meta text.
  Color get mutedTextColor {
    final Color base = Theme.of(this).textTheme.bodySmall?.color ?? Colors.grey;
    return base.applyOpacity(isDark ? 0.6 : 0.7);
  }

  /// Supporting captions ("Images only", file size hints).
  Color get tertiaryTextColor => isDark ? Colors.white54 : Colors.black45;

  Color get hintTextColor =>
      isDark ? AppColorsDark.hintTextColor : AppColorsLight.hintTextColor;

  //
  // skeletons
  /// Bone fill for loading skeletons. Bones sit on [flatCardColor], so this
  /// has to be darker than the card in light mode and lighter in dark mode.
  Color get skeletonBaseColor =>
      isDark ? Colors.white.applyOpacity(0.08) : const Color(0xFFE4E4E9);

  /// The travelling highlight of a shimmer sweep.
  Color get skeletonHighlightColor =>
      isDark ? Colors.white.applyOpacity(0.18) : const Color(0xFFF5F5F8);

  //
  // elevation
  /// Soft drop shadow under a floating card.
  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.applyOpacity(isDark ? 0.45 : 0.07),
          blurRadius: isDark ? 30 : 22,
          offset: const Offset(0, 14),
        ),
      ];

  /// Red glow behind an active brand CTA. [t] scales it out, for a button that
  /// shrinks as it travels (1 = full glow).
  List<BoxShadow> accentGlow([double t = 1]) => [
        BoxShadow(
          color: brandColor.applyOpacity(0.45 * t),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
