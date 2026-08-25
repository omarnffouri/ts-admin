import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ts_admin/app/modules/storage/presentation/storage_drive/controllers/storage_drive_controller.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';

part './recently_uploaded_loading_view.dart';
part './resources_loading_view.dart';

class StorageDriveLoadingView extends StatelessWidget {
  const StorageDriveLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //
        //
        // recently uploaded loading view
        RecentlyUploadedLoadingView(),

        //
        //
        // files, folders root view
        Expanded(
          child: RootResourcesLoadingView(),
        )
      ],
    );
  }
}
