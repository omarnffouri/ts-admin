import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/announcement_topic.dart';
import '../../controllers/create_announcement_controller.dart';
import 'category_dropdown_widget.dart';

/// Single-select dropdown of application-status topics. Broadcasts the
/// announcement to every driver subscribed to the chosen topic.
class TopicDropdownWidget extends GetView<CreateAnnouncementController> {
  const TopicDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: AnnouncementDropdown<AnnouncementTopic>(
          hintText: 'Select Topic',
          items: AnnouncementTopic.all,
          selectedItem: controller.selectedTopic.value,
          itemAsString: (topic) => topic.label,
          onChanged: (topic) => controller.selectedTopic.value = topic,
        ),
      ),
    );
  }
}
