class GetResourcesParams {
  final String? search;
  final String? resourceType;
  final int? parentId;

  GetResourcesParams({
    this.search,
    this.resourceType,
    this.parentId,
  });

  Map<String, dynamic> toJson() => {
        "search_string": search,
        "resource_type": resourceType,
        "parent_id": parentId,
      };
}
