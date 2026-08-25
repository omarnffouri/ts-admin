import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/controllers/conversations_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/entities/conversation_details_entity.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ParticipantsBottomSheet extends GetView<ChatDetailController> {
  const ParticipantsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    bool iAmAdmin = false;
    if (controller.conversationDetails.value != null) {
      if ((controller.conversationDetails.value!.participants ?? [])
          .isNotEmpty) {
        for (var item in controller.conversationDetails.value!.participants!) {
          if (item.id?.toString() == controller.myId &&
              item.modelType == "users") {
            iAmAdmin = item.isGroupAdmin ?? false;
            break;
          }
        }
      }
    }

    ConversationsController? conversationsController;
    if (Get.isRegistered<ConversationsController>()) {
      conversationsController = Get.find<ConversationsController>();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // top header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 50,
          decoration: const BoxDecoration(
            color: AppColorsLight.mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Row(children: [
            const Text(
              "Members",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            Obx(() =>
                ((controller.conversationDetails.value?.groupName != null) &&
                        iAmAdmin)
                    ? GestureDetector(
                        onTap: () {
                          if (controller.groupId.value == null) {
                            return;
                          }
                          controller.openAddParticipantsBottomSheet(
                            controller.groupId.value!,
                          );
                        },
                        child: const Icon(
                          Icons.add_box_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ).marginOnly(left: 10)
                    : const SizedBox()),
            const Spacer(),

            //
            //
            // chat details loading indicator
            Obx(
              () => Visibility(
                visible: controller.isLoadingChatDetails,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeCap: StrokeCap.round,
                  ),
                ).marginOnly(right: 15),
              ),
            ),

            //
            //
            // close button
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close_rounded,
                size: 25,
                color: Colors.white,
              ),
            )
          ]),
        ),

        Obx(() => (controller
                    .conversationDetails.value?.participants?.isNotEmpty ??
                false)
            ? Container(
                color: theme.scaffoldBackgroundColor,
                constraints: BoxConstraints(maxHeight: Get.height * 0.80),
                child: SlidableAutoCloseBehavior(
                  child: Obx(
                    () => ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller
                            .conversationDetails.value!.participants!.length,
                        itemBuilder: (context, index) {
                          // participant at index
                          final participant = controller
                              .conversationDetails.value!.participants![index];

                          return _ParticipantItemView(
                            participant: participant,
                            index: index,
                            iAmAdmin: iAmAdmin,
                            conversationsController: conversationsController,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Row(
                            children: [
                              const SizedBox(
                                width: 62,
                              ),
                              Expanded(
                                child: Divider(
                                  height: 0,
                                  color: Colors.grey.applyOpacity(0.2),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  children: [
                    const Text(
                      "No member found.",
                      style: TextStyle(
                          color: AppColorsLight.mainColor, fontSize: 16),
                    ).paddingOnly(top: 50),
                    const SizedBox(
                      height: 50,
                    ),
                    Obx(() => controller.isLoadingChatDetails
                        ? const CircularProgressIndicator(
                            color: AppColorsLight.mainColor,
                          )
                        : GestureDetector(
                            onTap: () {
                              controller.getChatDetails();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColorsLight.mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "Refresh",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ))
      ],
    );
  }
}

// ignore: must_be_immutable
class _ParticipantItemView extends GetView<ChatDetailController> {
  final ConversationWithParticipentEntity participant;
  final int index;
  final bool iAmAdmin;
  ConversationsController? conversationsController;

  //
  //
  _ParticipantItemView({
    required this.participant,
    required this.index,
    required this.iAmAdmin,
    this.conversationsController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final isGroupSuperAdmin =
        ((controller.conversationDetails.value!.modelId == participant.id) &&
            (modelTypeValues
                    .reverse[controller.conversationDetails.value!.modelType] ==
                participant.modelType));

    return Obx(
      () => Slidable(
        key: ValueKey(index),
        closeOnScroll: true,
        groupTag: "conversation_participants_slide_group",
        endActionPane: iAmAdmin &&
                (!isGroupSuperAdmin) &&
                (!controller.isRemovingParticipant) &&
                (!controller.isUpdatingParticipant)
            ? ActionPane(
                openThreshold: 0.1,
                extentRatio:
                    (participant.modelType == "applicants") ? 0.3 : 0.6,
                motion: const BehindMotion(),
                children: [
                  //
                  //
                  // group admin
                  if (participant.modelType != "applicants")
                    SlidableAction(
                      onPressed: (context) {
                        participant.isGroupAdmin =
                            !(participant.isGroupAdmin ?? false);
                        controller.updateParticipant(
                          participant,
                          index,
                        );
                      },
                      flex: 3,
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                      icon: (participant.isGroupAdmin ?? false)
                          ? Icons.person_remove_alt_1_rounded
                          : Icons.person_add_alt_1_rounded,
                      label: (participant.isGroupAdmin ?? false)
                          ? 'Remove Admin'
                          : 'Make Admin',
                    ),

                  //
                  //
                  // remove action
                  SlidableAction(
                    onPressed: (context) {
                      controller.showRemoveParticipantConfirmationDialog(
                          participant,
                          controller.conversationDetails.value!
                                  .participants![index].name ??
                              "",
                          index,
                          theme);
                    },
                    flex: (participant.modelType == "applicants") ? 1 : 2,
                    backgroundColor: AppColorsLight.mainColor,
                    foregroundColor: Colors.white,
                    icon: Icons.delete_forever_rounded,
                    label: 'Remove',
                  ),
                ],
              )
            : null,
        child: Container(
          margin: index == 0
              ? const EdgeInsets.only(left: 1, right: 1, top: 14)
              : index ==
                      (controller
                              .conversationDetails.value!.participants!.length -
                          1)
                  ? const EdgeInsets.only(left: 1, right: 1, bottom: 14)
                  : const EdgeInsets.symmetric(horizontal: 1),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              //
              //
              // profile image
              Stack(
                children: [
                  ProfileImage.network(
                      url: participant.image,
                      width: 45,
                      height: 45,
                      showLetterOnError: true,
                      letter: participant.name?[0].capitalize ?? ''),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: (conversationsController?.isUserOnline(
                                  participant.id, participant.modelType) ??
                              false)
                          ? AppColorsLight.onlineColor
                          : AppColorsLight.offlineColor,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 12),

              //
              //
              // name and desigination
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    // name
                    Text(
                      controller.conversationDetails.value!.participants![index]
                              .name ??
                          "",
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    //
                    // desigination
                    Text(
                      controller.conversationDetails.value!.participants![index]
                              .userDesignation ??
                          ((controller.conversationDetails.value!
                                          .participants![index].modelType ??
                                      "users") ==
                                  "users"
                              ? "Admin"
                              : "Driver"),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              //
              //
              // group admin label
              if (participant.isGroupAdmin ?? false)
                Text(
                  isGroupSuperAdmin ? "Creator" : "Group Admin",
                  style: const TextStyle(
                    color: AppColorsLight.mainColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              //
              //
              // delete/update progess
              Obx(
                () => Visibility(
                  visible: (controller.isRemovingParticipant &&
                          controller.removingAtIndex == index) ||
                      (controller.isUpdatingParticipant &&
                          controller.updatingParticipantAtIndex == index),
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColorsLight.mainColor,
                    ),
                  ).paddingSymmetric(horizontal: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
