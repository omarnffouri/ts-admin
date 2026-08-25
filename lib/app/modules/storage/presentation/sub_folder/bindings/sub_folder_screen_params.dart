import 'package:get/get.dart';
import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';

class SubFolderScreenParams {
  final RxString folderName;
  final int folderId;
  RxInt resourcesCount;
  final Rxn<ResourceEntity> resource;

  SubFolderScreenParams({
    required String folderName,
    required this.folderId,
    int? resourcesCount,
    Rxn<ResourceEntity>? resource,
  })  : resource = resource ?? Rxn<ResourceEntity>(null),
        resourcesCount = (resourcesCount ?? 0).obs,
        folderName = (folderName.obs);
}
