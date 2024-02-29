// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  String? id;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? plan;
  String? readingTitle;
  String? readingContentType;
  String? readingContent;
  String? consultationTitle;
  String? consultationContent;
  String? nutritionTitle;
  String? nutritionContent;
  String? activityTitle;
  String? activityContent;
  String? consultationContentType;
  String? nutritionContentType;
  String? activityContentType;
  int? day;

  Task({
    this.id,
    this.dateCreated,
    this.dateUpdated,
    this.plan,
    this.readingTitle,
    this.readingContentType,
    this.readingContent,
    this.consultationTitle,
    this.consultationContent,
    this.nutritionTitle,
    this.nutritionContent,
    this.activityTitle,
    this.activityContent,
    this.consultationContentType,
    this.nutritionContentType,
    this.activityContentType,
    this.day,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        plan: json["plan"],
        readingTitle: json["reading_title"],
        readingContentType: json["reading_content_type"],
        readingContent: json["reading_content"],
        consultationTitle: json["consultation_title"],
        consultationContent: json["consultation_content"],
        nutritionTitle: json["nutrition_title"],
        nutritionContent: json["nutrition_content"],
        activityTitle: json["activity_title"],
        activityContent: json["activity_content"],
        consultationContentType: json["consultation_content_type"],
        nutritionContentType: json["nutrition_content_type"],
        activityContentType: json["activity_content_type"],
        day: json["day"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "date_updated": dateUpdated?.toIso8601String(),
        "plan": plan,
        "reading_title": readingTitle,
        "reading_content_type": readingContentType,
        "reading_content": readingContent,
        "consultation_title": consultationTitle,
        "consultation_content": consultationContent,
        "nutrition_title": nutritionTitle,
        "nutrition_content": nutritionContent,
        "activity_title": activityTitle,
        "activity_content": activityContent,
        "consultation_content_type": consultationContentType,
        "nutrition_content_type": nutritionContentType,
        "activity_content_type": activityContentType,
        "day": day,
      };
}
