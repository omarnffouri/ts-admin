import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ts_admin/app/modules/chat_detail/data/enums/chat_info_tags.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/chat_info_tags_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_info_tags_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/suggestions_components/tag_item_view.dart';

part 'drivers_suggestion_view.dart';
part 'trucks_suggestion_view.dart';
part 'shipments_suggestion_view.dart';

class ChatSuggestionsView extends GetView<ChatDetailController> {
  const ChatSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        //
        //
        // drivers suggestion view
        Obx(
          () => Visibility(
            visible: controller
                    .chatInfoTagController.suggestedDrivers.isNotEmpty ||
                controller.chatInfoTagController.selectedDriver.value != null,
            child: FadeInLeft(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: const _DriversSuggestionView(),
            ),
          ),
        ),

        //
        //
        // trucks suggestion view
        Obx(
          () => Visibility(
            visible: controller
                    .chatInfoTagController.suggestedTrucks.isNotEmpty ||
                controller.chatInfoTagController.selectedTruck.value != null,
            child: FadeInLeft(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: const _TrucksSuggestionView(),
            ),
          ),
        ),

        //
        //
        // shipments suggestion view
        Obx(
          () => Visibility(
            visible: controller
                    .chatInfoTagController.suggestedShipments.isNotEmpty ||
                controller.chatInfoTagController.selectedShipment.value != null,
            child: FadeInLeft(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: const _ShipmentsSuggestionView(),
            ),
          ),
        ),
      ],
    );
  }
}
