import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/utils/functions.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/contact_entity.dart';
import 'package:ts_admin/app/modules/chat/domain/entities/group_conversation_entity.dart';
import 'package:ts_admin/app/modules/chat/presentation/conversations/views/components/chat_empty_state.dart';

import '../controllers/contacts_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingContacts
          ? buildLoadingView()
          : Column(
              children: [
                //
                // search bar

                // search field
                // Container(
                //   margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Get.isDarkMode
                //         ? Colors.black54
                //         : Colors.grey[300], // Background color
                //   ),
                //   child: TextField(
                //       controller: controller.searchTextController,
                //       maxLines: 1,
                //       decoration: InputDecoration(
                //         // contentPadding: EdgeInsets.all(0),
                //         hintText: "Search contacts by name, phone",
                //         border: InputBorder.none,
                //         focusedBorder: InputBorder.none,
                //         errorBorder: InputBorder.none,
                //         enabledBorder: InputBorder.none,
                //         disabledBorder: InputBorder.none,
                //         focusedErrorBorder:
                //             InputBorder.none, // Remove the default border
                //         icon: const Icon(
                //           Icons.search,
                //           color: Colors.grey,
                //         ),
                //         suffixIcon: GestureDetector(
                //           onTap: () {
                //             controller.clearSearch();
                //           },
                //           child: const Icon(
                //             Icons.close_rounded,
                //             color: Colors.grey,
                //           ),
                //         ),
                //       ) // Optional icon
                //       ),
                // ),

                //
                // body or list
                Expanded(
                  child: LayoutBuilder(builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return Obx(() => SmartRefresher(
                          controller: controller.contactRefreshController,
                          header: const WaterDropMaterialHeader(),
                          onRefresh: () async {
                            await controller.getAllContacts();
                            controller.contactRefreshController
                                .refreshCompleted();
                          },
                          child: controller.contacts.isEmpty
                              ? const ChatEmptyState(
                                  icon: Icons.contacts_outlined,
                                  title: "No contacts yet",
                                  subtitle:
                                      "People you can chat with will show up here",
                                )
                              : ListView.separated(
                                  itemCount: controller.isSearchEnabled.value
                                      ? controller.filteredContacts.length
                                      : controller.contacts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final ContactEntity contact = controller
                                            .isSearchEnabled.value
                                        ? controller.filteredContacts
                                            .elementAt(index)
                                        : controller.contacts.elementAt(index);
                                    return _ContactTile(
                                      index: index,
                                      contact: contact,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      height: 1,
                                      thickness: 1,
                                      indent: 76,
                                      endIndent: 16,
                                      color: Colors.grey.applyOpacity(0.12),
                                    );
                                  },
                                ),
                        ));
                  }),
                ),
              ],
            ),
    );
  }

  Widget buildLoadingView() {
    return ListView.separated(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white30,
          child: Container(
            margin: index == 0
                ? const EdgeInsets.only(left: 1, right: 1, top: 14)
                : index == (controller.contacts.length - 1)
                    ? const EdgeInsets.only(left: 1, right: 1, bottom: 14)
                    : const EdgeInsets.symmetric(horizontal: 1),
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const SizedBox(
                  width: 80,
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            const SizedBox(
              width: 62,
            ),
            Expanded(
              child: Divider(
                height: 5,
                color: Colors.grey.applyOpacity(0.2),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContactTile extends GetView<ContactsController> {
  final int index;

  final ContactEntity contact;
  const _ContactTile({
    required this.index,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme using the MediaQuery or Theme widget
    ThemeData theme = Theme.of(context);

    final String? subtitle = (contact.designation?.isNotEmpty ?? false)
        ? contact.designation
        : contact.phone;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColorsLight.mainColor.applyOpacity(0.06),
        highlightColor: AppColorsLight.mainColor.applyOpacity(0.03),
        onTap: () {
          controller.createNewConversation(
              contact.id?.toString() ?? "",
              modelTypeValues.reverse[contact.modelType] ?? "applicants",
              index);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showImageDialog(
                    context,
                    contact.image ?? "",
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ProfileImage.network(
                    url: contact.image ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmG52pVI5JZfn04j9gdtsd8pAGbqjjLswg&usqp=CAU",
                    width: 48,
                    height: 48,
                    showLetterOnError: true,
                    letter: contact.name?[0].toUpperCase() ?? "",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      contact.name ?? "",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Get.isDarkMode
                              ? Colors.white54
                              : AppColorsLight.textColor.applyOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => controller.isCreatingNewConversation &&
                      controller.creatingConverstionAtIndex == index
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Get.isDarkMode
                            ? Colors.white
                            : AppColorsLight.mainColor,
                      ))
                  : Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColorsLight.mainColor
                            .applyOpacity(Get.isDarkMode ? 0.16 : 0.08),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 17,
                        color: AppColorsLight.mainColor,
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
