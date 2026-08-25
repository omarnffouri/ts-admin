class DeleteResourcesParams {
  final List<int> ids;

  DeleteResourcesParams({
    required this.ids,
  });

  Map<String, dynamic> toJson() => {
        "ids": List<dynamic>.from(ids.map((x) => x)),
      };
}
