import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_entity.dart';

TaskListingDataEntity taskListingDataEntityFromJson(String str) =>
    TaskListingDataEntity.fromJson(json.decode(str));

String taskListingDataEntityToJson(TaskListingDataEntity data) =>
    json.encode(data.toJson());

class TaskListingDataEntity extends Equatable {
  final List<TaskEntity>? todo;
  final List<TaskEntity>? completed;
  final List<TaskEntity>? requested;

  const TaskListingDataEntity({
    this.todo,
    this.completed,
    this.requested,
  });

  factory TaskListingDataEntity.fromJson(Map<String, dynamic> json) =>
      TaskListingDataEntity(
        todo: json["todo"] == null
            ? []
            : List<TaskEntity>.from(
                json["todo"]!.map((x) => TaskEntity.fromJson(x))),
        completed: json["completed"] == null
            ? []
            : List<TaskEntity>.from(
                json["completed"]!.map((x) => TaskEntity.fromJson(x))),
        requested: json["requestedTo"] == null
            ? []
            : List<TaskEntity>.from(
                json["requestedTo"]!.map((x) => TaskEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "todo": todo == null
            ? []
            : List<dynamic>.from(todo!.map((x) => x.toJson())),
        "completed": completed == null
            ? []
            : List<dynamic>.from(completed!.map((x) => x.toJson())),
        "requestedTo": requested == null
            ? []
            : List<dynamic>.from(requested!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        todo,
        completed,
        requested,
      ];
}
