class RevokeResourcePermissionParams {
  final int id;
  final int userId;

  RevokeResourcePermissionParams({
    required this.id,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
      };
}
