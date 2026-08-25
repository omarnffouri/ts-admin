import 'package:ts_admin/app/modules/storage/domain/entities/resource_entity.dart';

class ResourceDetailsResult {
  final bool needRefresh;
  final ResourceEntity resource;

  ResourceDetailsResult({
    required this.needRefresh,
    required this.resource,
  });
}
