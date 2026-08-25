class RenameResourceParams {
  final int id;
  final int? parentId;
  final String resourceName;
  final String resourceType;

  RenameResourceParams({
    required this.id,
    this.parentId,
    required this.resourceName,
    required this.resourceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resource_type': resourceType,
      'resource_name': resourceName,
      'parent_id': parentId,
    };
  }
}
