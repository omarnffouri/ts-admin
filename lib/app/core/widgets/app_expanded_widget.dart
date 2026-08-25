import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppExpandedWidget extends StatefulWidget {
  AppExpandedWidget({
    super.key,
    required this.expand,
    this.header,
    required this.child,
    this.callback,
    required this.expandController,
  });
  final bool expand;
  final Widget? header;
  final Widget child;
  final Function()? callback;
  AnimationController expandController;

  @override
  State<AppExpandedWidget> createState() => _AppExpandedWidgetState();
}

class _AppExpandedWidgetState extends State<AppExpandedWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  VoidCallback? _callbackListener;

  // final showDownArrow = 0.0.obs;
  // final showUpArrow = 0.0.obs;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();

    // Adding a listener (the controller is owned externally, so keep a
    // reference to remove it again in dispose).
    if (widget.callback != null) {
      _callbackListener = widget.callback;
      widget.expandController.addListener(_callbackListener!);
    }
  }

  ///Setting up the animation
  void prepareAnimations() {
    // widget.expandController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 300),
    // );
    animation = CurvedAnimation(
      parent: widget.expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    // The controller is owned externally and may already be disposed if the
    // owner (e.g. a GetX controller) was torn down before this widget.
    if (!mounted) return;
    if (widget.expand) {
      widget.expandController.forward();
    } else {
      widget.expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AppExpandedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    // Do NOT dispose expandController here — it is owned by the caller
    // (passed in via the constructor) and disposing it would crash any other
    // user of the same controller. Only remove the listener we added.
    if (_callbackListener != null) {
      widget.expandController.removeListener(_callbackListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header ?? Container(),
        SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1.0,
          child: widget.child,
        ),
      ],
    );
  }
}
