// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../domain/enitities/shipment_entity.dart';
import '../../controllers/shipments_controller.dart';
import 'expansion_body.dart';
import 'expansion_title.dart';

class ExpandedCard extends StatefulWidget {
  final bool expand;
  final ShipmentEntity shipment;

  const ExpandedCard({
    super.key,
    required this.shipment,
    this.expand = false,
  });

  @override
  _ExpandedCardState createState() => _ExpandedCardState();
}

class _ExpandedCardState extends State<ExpandedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  final controller = Get.find<ShipmentsController>();

  final showDownArrow = 0.0.obs;

  final showUpArrow = 0.0.obs;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();

    expandController.addListener(() {
      showDownArrow.value = expandController.value;
      showUpArrow.value = expandController.value;
    });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 2.h),
        child: Column(
          children: [
            ExpansionTitle(
              shipment: widget.shipment,
              showArrow: showDownArrow,
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: ExpansionBody(
                  shipment: widget.shipment,
                  showArrow: showUpArrow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
