import 'dart:convert';

import 'package:ts_admin/app/modules/task_management/data/models/task_model.dart';
import 'package:ts_admin/app/modules/task_management/domain/entities/task_listing_data_entity.dart';

TaskListingDataModel taskListingDataEntityFromJson(String str) =>
    TaskListingDataModel.fromJson(json.decode(str));

String taskListingDataEntityToJson(TaskListingDataModel data) =>
    json.encode(data.toJson());

class TaskListingDataModel extends TaskListingDataEntity {
  const TaskListingDataModel({
    super.todo,
    super.completed,
    super.requested,
  });

  factory TaskListingDataModel.fromJson(Map<String, dynamic> json) =>
      TaskListingDataModel(
        todo: json["todo"] == null
            ? []
            : List<TaskModel>.from(
                json["todo"]!.map((x) => TaskModel.fromJson(x))),
        completed: json["completed"] == null
            ? []
            : List<TaskModel>.from(
                json["completed"]!.map((x) => TaskModel.fromJson(x))),
        requested: json["requestedTo"] == null
            ? []
            : List<TaskModel>.from(
                json["requestedTo"]!.map((x) => TaskModel.fromJson(x))),
      );

  @override
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
}
