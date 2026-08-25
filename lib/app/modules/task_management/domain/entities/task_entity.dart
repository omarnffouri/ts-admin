import 'dart:convert';

import 'package:equatable/equatable.dart';

TaskEntity taskEntityFromJson(String str) =>
    TaskEntity.fromJson(json.decode(str));

String taskEntityToJson(TaskEntity data) => json.encode(data.toJson());

// ignore: must_be_immutable
class TaskEntity extends Equatable {
  final int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  String? description;
  String? category;
  DateTime? dueDate;
  String? reportsToName;
  String? assignedToName;
  int? reportsToId;
  int? assignedToId;
  int? percentage;
  TaskUserEntity? reportsTo;
  TaskUserEntity? assignedTo;
  String? status;
  List<TaskStatusEntity>? statuses;
  TaskFileEntity? file;

  TaskEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.category,
    this.dueDate,
    this.reportsToName,
    this.assignedToName,
    this.reportsToId,
    this.assignedToId,
    this.percentage,
    this.reportsTo,
    this.assignedTo,
    this.status,
    this.statuses,
    this.file,
  });

  update(TaskEntity? task) {
    updatedAt = task?.updatedAt;
    title = task?.title;
    description = task?.description;
    category = task?.category;
    dueDate = task?.dueDate;
    reportsToName = task?.reportsToName;
    assignedToName = task?.assignedToName;
    reportsToId = task?.reportsToId;
    assignedToId = task?.assignedToId;
    percentage = task?.percentage;
    reportsTo = task?.reportsTo;
    assignedTo = task?.assignedTo;
    status = task?.status;
    statuses = task?.statuses;
    file = task?.file;
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
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
            : TaskUserEntity.fromJson(json["reportsTo"]),
        assignedTo: json["assignedTo"] == null
            ? null
            : TaskUserEntity.fromJson(json["assignedTo"]),
        status: json["status"],
        statuses: json["statuses"] == null
            ? []
            : List<TaskStatusEntity>.from(
                json["statuses"]!.map((x) => TaskStatusEntity.fromJson(x))),
        file:
            json["file"] == null ? null : TaskFileEntity.fromJson(json["file"]),
      );

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

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        title,
        description,
        category,
        dueDate,
        reportsToName,
        assignedToName,
        reportsToId,
        assignedToId,
        percentage,
        reportsTo,
        assignedTo,
        status,
        statuses,
        file,
      ];

  // String getFormatedDueDate() {
  //   if (dueDate == null) {
  //     return "N/A";
  //   }
  //   return DateFormat('dd-MMM-yyyy').format(dueDate!);
  // }

  // String getFormatedCreatedAt() {
  //   if (createdAt == null) {
  //     return "N/A";
  //   }
  //   return DateFormat('dd-MMM-yyyy').format(createdAt!);
  // }

  // String getFormatedUpdatedAt() {
  //   if (updatedAt == null) {
  //     return "N/A";
  //   }
  //   return DateFormat('dd-MMM-yyyy').format(updatedAt!);
  // }

  String getFormatedRemainingTime() {
    if (dueDate == null) {
      return '';
    }

    if (DateTime.now().isAfter(dueDate!)) {
      return '';
    }

    // Get the difference between the two dates
    Duration diff = dueDate!.difference(DateTime.now());

    // Extract days, hours, and minutes
    int days = diff.inDays;
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;

    String time = '';

    // Build the formatted string based on the conditions

    if (minutes > 0) {
      time = "${minutes}m";
    }

    if (hours > 0) {
      time = "${hours}h${(minutes > 0) ? (" - $time") : ""}";
    }

    if (days > 0) {
      time = "${days}d${(minutes > 0 || hours > 0) ? (" - $time") : ""}";
    }

    return time;
  }

  int getDueDays() {
    if (dueDate == null) {
      return 0;
    }

    if (DateTime.now().isAfter(dueDate!)) {
      return 0;
    }

    // Get the difference between the two dates
    Duration diff = dueDate!.difference(DateTime.now());

    // Extract days
    return diff.inDays;
  }

  int getDueHours() {
    if (dueDate == null) {
      return 0;
    }

    if (DateTime.now().isAfter(dueDate!)) {
      return 0;
    }

    // Get the difference between the two dates
    Duration diff = dueDate!.difference(DateTime.now());

    // Extract  hours
    return diff.inHours % 24;
  }

  int getDueMinutes() {
    if (dueDate == null) {
      return 0;
    }

    if (DateTime.now().isAfter(dueDate!)) {
      return 0;
    }

    // Get the difference between the two dates
    Duration diff = dueDate!.difference(DateTime.now());

    // Extract  minutes
    return diff.inMinutes % 60;
  }

  bool isPending() => (status ?? "").toLowerCase() == "pending";
  bool isInprogress() => (status ?? "").toLowerCase() == "in_progress";
  bool isCompleted() => (status ?? "").toLowerCase() == "completed";

  String getStatus() => isInprogress()
      ? "In-Progress"
      : isCompleted()
          ? " Completed"
          : "Pending";
}

// ignore: must_be_immutable
class TaskUserEntity extends Equatable {
  int? id;
  String? name;
  String? image;

  TaskUserEntity({
    this.id,
    this.name,
    this.image,
  });

  factory TaskUserEntity.fromJson(Map<String, dynamic> json) => TaskUserEntity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        image,
      ];
}

class TaskFileEntity extends Equatable {
  final int? id;
  final String? fileType;
  final String? name;
  final String? fileName;
  final String? fileNameExt;
  final String? url;
  final String? mimeType;

  const TaskFileEntity({
    this.id,
    this.fileType,
    this.name,
    this.fileName,
    this.fileNameExt,
    this.url,
    this.mimeType,
  });

  factory TaskFileEntity.fromJson(Map<String, dynamic> json) => TaskFileEntity(
        id: json["id"],
        fileType: json["file_type"],
        name: json["name"],
        fileName: json["file_name"],
        fileNameExt: json["file_name_ext"],
        url: json["url"],
        mimeType: json["mime_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_type": fileType,
        "name": name,
        "file_name": fileName,
        "file_name_ext": fileNameExt,
        "url": url,
        "mime_type": mimeType,
      };

  @override
  List<Object?> get props => [
        id,
        fileType,
        name,
        fileName,
        fileNameExt,
        url,
        mimeType,
      ];
}

class TaskStatusEntity extends Equatable {
  final int? id;
  final String? name;
  final String? reason;
  final String? modelType;
  final int? modelId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskStatusEntity({
    this.id,
    this.name,
    this.reason,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskStatusEntity.fromJson(Map<String, dynamic> json) =>
      TaskStatusEntity(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        reason,
        modelType,
        modelId,
        createdAt,
        updatedAt,
      ];

  bool isPending() => (name ?? "").toLowerCase() == "pending";
  bool isInprogress() => (name ?? "").toLowerCase() == "in_progress";
  bool isCompleted() => (name ?? "").toLowerCase() == "completed";

  String getStatus() => isInprogress()
      ? "In-Progress"
      : isCompleted()
          ? " Completed"
          : "Pending";
}
