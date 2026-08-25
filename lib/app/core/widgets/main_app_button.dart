import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

/// Shared brand-gradient action button with loading, press, and subtle pulse
/// feedback. Callers keep ownership of their action and loading state.
class MainAppButton extends StatefulWidget {
  const MainAppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.height = 48,
    this.borderRadius = 12,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  @override
  State<MainAppButton> createState() => _MainAppButtonState();
}

class _MainAppButtonState extends State<MainAppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulseController.stop();
      _pulseController.value = 0;
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: widget.label,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE50914).applyOpacity(
                    0.08 + (_pulseController.value * 0.06),
                  ),
                  blurRadius: 10 + (_pulseController.value * 8),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: isEnabled ? widget.onPressed : null,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 185, 12, 24),
                    Color.fromARGB(255, 190, 6, 15),
                    Color(0xFF780008),
                  ],
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: widget.height),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.leadingIcon != null) ...[
                                widget.leadingIcon!,
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  widget.label,
                                  textAlign: TextAlign.center,
                                  style: widget.textStyle ??
                                      Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                ),
                              ),
                              if (widget.trailingIcon != null) ...[
                                const SizedBox(width: 8),
                                widget.trailingIcon!,
                              ],
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
