class CreateFolderParams {
  final int? parentId;
  final String resourceName;

  CreateFolderParams({
    this.parentId,
    required this.resourceName,
  });

  Map<String, dynamic> toJson() {
    //
    // passing hard code type of resource "folder"
    return {
      'resource_type': "folder",
      'parent_id': parentId,
      'resource_name': resourceName
    };
  }
}
