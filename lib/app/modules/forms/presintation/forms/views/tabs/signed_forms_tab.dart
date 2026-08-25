import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/core/widgets/empty_state_view.dart';
import 'package:ts_admin/app/modules/forms/domain/entities/form_entity.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/controllers/forms_controller.dart';
import 'package:ts_admin/app/modules/forms/presintation/forms/views/components/forms_list_card_view.dart';

class SignedFormsTab extends GetView<FormsController> {
  const SignedFormsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? _buildLoadingView(context)
          : Obx(
              () => SmartRefresher(
                controller: controller.signedFormsRrefreshController,
                header: const WaterDropMaterialHeader(),
                onRefresh: controller.handleRefresh,
                child: controller.signedForms.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.history_edu_rounded,
                        title: "No signed forms yet",
                        message:
                            "Once forms are signed, they will appear here for your records.",
                      )
                    : controller.isSearchEnabled.value
                        ? _buildFilteredList()
                        : _buildNormalList(),
              ),
            ),
    );
  }

  Widget _buildNormalList() {
    return ListView.builder(
      itemCount: controller.signedForms.length,
      itemBuilder: (BuildContext context, int index) {
        final FormEntity formEntity = controller.signedForms[index];
        return FormListCardView(
          formEntity: formEntity,
          index: index,
          isPending: false,
        );
      },
    );
  }

  Widget _buildFilteredList() {
    if (controller.filteredSignedForms.isEmpty) {
      return const EmptyStateView(
        icon: Icons.search_off_rounded,
        title: "No matches found",
        message: "No signed forms match your search. Try a different name.",
      );
    }

    return ListView.builder(
      itemCount: controller.filteredSignedForms.length,
      itemBuilder: (BuildContext context, int index) {
        final FormEntity formEntity = controller.filteredSignedForms[index];
        return FormListCardView(
          formEntity: formEntity,
          index: index,
          isPending: false,
        );
      },
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.white10 : Colors.black12,
          highlightColor: isDark ? Colors.white24 : Colors.white30,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: 84,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
