import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/widgets/main_app_button.dart';

import '../components/trailer_document_item.dart';

class NewTrailerDocumentButtomsheet extends StatelessWidget {
  const NewTrailerDocumentButtomsheet({
    super.key,
    required this.isUploading,
    required this.onPressed,
    required this.docsKey,
  });
  final GlobalKey<AnimatedListState> docsKey;
  final RxBool isUploading;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedList(
            key: docsKey,
            initialItemCount: 1,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                axis: Axis.vertical,
                sizeFactor: animation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TrailerDocumentItem(index: index),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => MainAppButton(
              label: "Upload",
              isLoading: isUploading.value,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
