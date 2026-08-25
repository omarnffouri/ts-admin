import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

/// Stable identifiers for each step of the quick-shipment stepper. Widgets
/// and controllers should key off these instead of the visible [title], so
/// renaming a step never breaks state lookups.
enum QuickShipmentStepId {
  customer,
  driver,
  truckTrailer,
  contractedAmount,
  confirmationFile,
}

/// Visual/interaction state of a single step. `error` is a variant of the
/// active step shown when the user tried to continue but validation failed;
/// it stays expanded so the message is visible next to the offending field.
enum QuickShipmentStepState { upcoming, active, completed, error, disabled }

/// Everything one row of the [QuickShipmentStepper] needs to render itself.
/// Every step is built from this same shape so the header, card, spacing and
/// animation stay identical across the whole flow — only these values change.
class QuickShipmentStepConfig {
  const QuickShipmentStepConfig({
    required this.id,
    required this.title,
    required this.icon,
    required this.state,
    required this.content,
    this.summary,
    this.errorText,
  });

  final QuickShipmentStepId id;
  final String title;
  final IconData icon;
  final QuickShipmentStepState state;
  final Widget content;

  /// Compact "here's what you picked" line shown once the step is completed.
  final String? summary;

  /// Inline validation message shown when [state] is [QuickShipmentStepState.error].
  final String? errorText;
}

/// A vertical, single-source-of-truth stepper: every step is rendered by the
/// exact same row/card/connector combination, only [QuickShipmentStepConfig]
/// changes between them. The active step auto-scrolls into view.
class QuickShipmentStepper extends StatefulWidget {
  const QuickShipmentStepper({
    super.key,
    required this.steps,
    required this.onStepTapped,
  });

  final List<QuickShipmentStepConfig> steps;
  final void Function(QuickShipmentStepId id) onStepTapped;

  @override
  State<QuickShipmentStepper> createState() => _QuickShipmentStepperState();
}

class _QuickShipmentStepperState extends State<QuickShipmentStepper> {
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(widget.steps.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant QuickShipmentStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.steps.length != widget.steps.length) {
      _keys = List<GlobalKey>.generate(widget.steps.length, (_) => GlobalKey());
      return;
    }

    final int oldActive = oldWidget.steps.indexWhere(
      (s) =>
          s.state == QuickShipmentStepState.active ||
          s.state == QuickShipmentStepState.error,
    );
    final int newActive = widget.steps.indexWhere(
      (s) =>
          s.state == QuickShipmentStepState.active ||
          s.state == QuickShipmentStepState.error,
    );

    if (newActive != -1 && newActive != oldActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = _keys[newActive].currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            alignment: 0.08,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    final Duration duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.steps.length; i++) ...[
          if (i > 0)
            StepConnector(
              filled:
                  widget.steps[i - 1].state == QuickShipmentStepState.completed,
            ),
          KeyedSubtree(
            key: _keys[i],
            child: _QuickShipmentStepItem(
              index: i,
              total: widget.steps.length,
              step: widget.steps[i],
              animationDuration: duration,
              onTap: () => widget.onStepTapped(widget.steps[i].id),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickShipmentStepItem extends StatelessWidget {
  const _QuickShipmentStepItem({
    required this.index,
    required this.total,
    required this.step,
    required this.animationDuration,
    required this.onTap,
  });

  final int index;
  final int total;
  final QuickShipmentStepConfig step;
  final Duration animationDuration;
  final VoidCallback onTap;

  bool get _tappable =>
      step.state == QuickShipmentStepState.completed ||
      step.state == QuickShipmentStepState.error;

  bool get _expanded =>
      step.state == QuickShipmentStepState.active ||
      step.state == QuickShipmentStepState.error;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${_stateLabel(step.state)}. Step ${index + 1} of $total, ${step.title}',
      button: _tappable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _tappable ? onTap : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: QuickShipmentStepHeader(
                  index: index,
                  title: step.title,
                  icon: step.icon,
                  state: step.state,
                  summary: step.summary,
                  errorText: step.errorText,
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(left: 54, top: 8, bottom: 6),
                    child: step.content,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  String _stateLabel(QuickShipmentStepState state) {
    switch (state) {
      case QuickShipmentStepState.active:
        return 'Current step';
      case QuickShipmentStepState.completed:
        return 'Completed step';
      case QuickShipmentStepState.error:
        return 'Step with error';
      case QuickShipmentStepState.disabled:
        return 'Disabled step';
      case QuickShipmentStepState.upcoming:
        return 'Upcoming step';
    }
  }
}

/// Indicator circle + title (+ optional summary/error line). Identical
/// layout for every step; only colors, icon and text change with [state].
class QuickShipmentStepHeader extends StatelessWidget {
  const QuickShipmentStepHeader({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.state,
    this.summary,
    this.errorText,
  });

  final int index;
  final String title;
  final IconData icon;
  final QuickShipmentStepState state;
  final String? summary;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = context.isDark;
    final Color accent = context.brandColor;
    final Color successColor =
        dark ? Colors.green.shade300 : Colors.green.shade700;
    final Color errorColor = theme.colorScheme.error;

    Color indicatorFill;
    Color indicatorBorder;
    Widget indicatorChild;
    Color titleColor;
    FontWeight titleWeight;

    switch (state) {
      case QuickShipmentStepState.active:
        indicatorFill = accent;
        indicatorBorder = accent;
        indicatorChild = Icon(icon, size: 19, color: Colors.white);
        titleColor = context.primaryTextColor;
        titleWeight = FontWeight.w700;
        break;
      case QuickShipmentStepState.completed:
        indicatorFill = successColor.applyOpacity(dark ? 0.20 : 0.12);
        indicatorBorder = successColor;
        indicatorChild =
            Icon(Icons.check_rounded, size: 20, color: successColor);
        titleColor = context.primaryTextColor;
        titleWeight = FontWeight.w600;
        break;
      case QuickShipmentStepState.error:
        indicatorFill = errorColor.applyOpacity(dark ? 0.22 : 0.10);
        indicatorBorder = errorColor;
        indicatorChild =
            Icon(Icons.priority_high_rounded, size: 20, color: errorColor);
        titleColor = errorColor;
        titleWeight = FontWeight.w700;
        break;
      case QuickShipmentStepState.disabled:
        indicatorFill = Colors.transparent;
        indicatorBorder = context.hairlineBorderColor;
        indicatorChild = Icon(icon, size: 17, color: context.tertiaryTextColor);
        titleColor = context.tertiaryTextColor;
        titleWeight = FontWeight.w500;
        break;
      case QuickShipmentStepState.upcoming:
        indicatorFill = Colors.transparent;
        indicatorBorder = context.hairlineBorderColor;
        indicatorChild = Text(
          '${index + 1}',
          style: TextStyle(
            color: context.secondaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        );
        titleColor = context.secondaryTextColor;
        titleWeight = FontWeight.w600;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: indicatorFill,
            shape: BoxShape.circle,
            border: Border.all(color: indicatorBorder, width: 1.6),
          ),
          alignment: Alignment.center,
          child: indicatorChild,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style:
                    (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
                  color: titleColor,
                  fontWeight: titleWeight,
                  fontSize: 15.5,
                ),
                child:
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (state == QuickShipmentStepState.completed &&
                  (summary ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    summary!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.tertiaryTextColor,
                    ),
                  ),
                ),
              if (state == QuickShipmentStepState.error &&
                  (errorText ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 13, color: errorColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          errorText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: errorColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (state == QuickShipmentStepState.active ||
            state == QuickShipmentStepState.error)
          Icon(Icons.expand_less_rounded, color: context.secondaryTextColor)
        else
          Icon(
            Icons.expand_more_rounded,
            color: context.tertiaryTextColor.applyOpacity(0.6),
          ),
      ],
    );
  }
}

/// Vertical line between two step indicators. Green once the step above it
/// is completed, a hairline otherwise — the single connector style reused
/// between every pair of steps.
class StepConnector extends StatelessWidget {
  const StepConnector({super.key, required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Color color = filled
        ? (dark ? Colors.green.shade300 : Colors.green.shade700)
        : context.hairlineBorderColor;

    return Padding(
      padding: const EdgeInsets.only(left: 19.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        width: 1.6,
        height: 22,
        color: color,
      ),
    );
  }
}

/// Themed card every step's form content lives inside — identical surface,
/// radius, border and padding regardless of which step is showing.
class StepContentCard extends StatelessWidget {
  const StepContentCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tileColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Back / Next / Submit action row shared by every step so button position,
/// sizing and styling never change as the user moves through the flow.
class StepNavigationBar extends StatelessWidget {
  const StepNavigationBar({
    super.key,
    required this.onNext,
    required this.nextLabel,
    this.onBack,
    this.isLoading = false,
    this.nextIcon = Icons.arrow_forward_rounded,
  });

  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String nextLabel;
  final bool isLoading;
  final IconData nextIcon;

  @override
  Widget build(BuildContext context) {
    final Color accent = context.brandColor;

    return Row(
      children: [
        if (onBack != null) ...[
          Semantics(
            button: true,
            label: 'Back to previous step',
            child: Material(
              color: context.surfaceVariantColor,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: isLoading ? null : onBack,
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: context.primaryTextColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Semantics(
            button: true,
            label: nextLabel,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: isLoading ? null : onNext,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accent.applyOpacity(0.30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isLoading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                              strokeCap: StrokeCap.round,
                            ),
                          )
                        : Row(
                            key: const ValueKey('label'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                nextLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(nextIcon, size: 18, color: Colors.white),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Inline banner shown above a step's fields when that step failed
/// validation — communicates the error with icon + text, not color alone.
class StepErrorBanner extends StatelessWidget {
  const StepErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Theme.of(context).colorScheme.error;
    final bool dark = context.isDark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: errorColor.applyOpacity(dark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: errorColor.applyOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: errorColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: errorColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
