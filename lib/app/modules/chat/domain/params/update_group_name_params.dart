// To parse this JSON data, do
//

class UpdateGroupNameParams {
  final int groupId;
  final bool autoAddDrivers;
  final String fromGroupName;
  final String toGroupName;

  const UpdateGroupNameParams({
    required this.groupId,
    required this.autoAddDrivers,
    required this.fromGroupName,
    required this.toGroupName,
  });

  Map<String, dynamic> toJson() => {
        "group_head_id": groupId,
        "auto_add_drivers": autoAddDrivers,
        "fromGroupName": fromGroupName,
        "toGroupName": toGroupName,
      };
}
