import 'dart:convert';

import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

// ignore: must_be_immutable
class TaskModel extends TaskEntity {
  TaskModel({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.title,
    super.description,
    super.category,
    super.dueDate,
    super.reportsToName,
    super.assignedToName,
    super.reportsToId,
    super.assignedToId,
    super.percentage,
    super.reportsTo,
    super.assignedTo,
    super.status,
    super.statuses,
    super.file,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        title: json["title"],
        description: json["description"],
        category: json["category"],
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        reportsToName: json["reports_to_name"],
        assignedToName: json["assigned_to_name"],
        reportsToId: json["reports_to"],
        assignedToId: json["assigned_to"],
        percentage: json["percentage"],
        reportsTo: json["reportsTo"] == null
            ? null
            : TaskUserModel.fromJson(json["reportsTo"]),
        assignedTo: json["assignedTo"] == null
            ? null
            : TaskUserModel.fromJson(json["assignedTo"]),
        status: json["status"],
        statuses: json["statuses"] == null
            ? []
            : List<TaskStatusModel>.from(
                json["statuses"]!.map((x) => TaskStatusModel.fromJson(x))),
        file:
            json["file"] == null ? null : TaskFileModel.fromJson(json["file"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "title": title,
        "description": description,
        "category": category,
        "due_date": dueDate?.toIso8601String(),
        "reports_to_name": reportsToName,
        "assigned_to_name": assignedToName,
        "reports_to": reportsToId,
        "assigned_to": assignedToId,
        "percentage": percentage,
        "reportsTo": reportsTo?.toJson(),
        "assignedTo": assignedTo?.toJson(),
        "status": status,
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toJson())),
        "file": file?.toJson(),
      };
}

// ignore: must_be_immutable
class TaskUserModel extends TaskUserEntity {
  TaskUserModel({
    super.id,
    super.name,
    super.image,
  });

  factory TaskUserModel.fromJson(Map<String, dynamic> json) => TaskUserModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class TaskFileModel extends TaskFileEntity {
  const TaskFileModel({
    super.id,
    super.fileType,
    super.name,
    super.fileName,
    super.fileNameExt,
    super.url,
    super.mimeType,
  });

  factory TaskFileModel.fromJson(Map<String, dynamic> json) => TaskFileModel(
        id: json["id"],
        fileType: json["file_type"],
        name: json["name"],
        fileName: json["file_name"],
        fileNameExt: json["file_name_ext"],
        url: json["url"],
        mimeType: json["mime_type"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "file_type": fileType,
        "name": name,
        "file_name": fileName,
        "file_name_ext": fileNameExt,
        "url": url,
        "mime_type": mimeType,
      };
}

class TaskStatusModel extends TaskStatusEntity {
  const TaskStatusModel({
    super.id,
    super.name,
    super.reason,
    super.modelType,
    super.modelId,
    super.createdAt,
    super.updatedAt,
  });

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) =>
      TaskStatusModel(
        id: json["id"],
        name: json["name"],
        reason: json["reason"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
