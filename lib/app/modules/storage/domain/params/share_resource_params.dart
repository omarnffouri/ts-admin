class ShareResourceParams {
  final List<int> users;
  final int resourceId;
  final String permission;

  ShareResourceParams({
    required this.users,
    required this.resourceId,
    required this.permission,
  });

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x)),
        "resource_id": resourceId,
        "permission": permission,
      };
}
