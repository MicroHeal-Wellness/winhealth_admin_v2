import 'dart:convert';

import 'package:winhealth_admin_v2/models/attachment.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  String? id;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? content;
  Attachment? attachment;
  String? patient;
  UserModel? userCreated;
  UserModel? userUpdated;

  Note({
    this.id,
    this.dateCreated,
    this.dateUpdated,
    this.content,
    this.attachment,
    this.patient,
    this.userCreated,
    this.userUpdated,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        content: json["content"],
        attachment: json["attachment"] == null
            ? null
            : Attachment.fromJson(json["attachment"]),
        patient: json["patient"],
        userCreated: json["user_created"] == null
            ? null
            : UserModel.fromJson(json["user_created"]),
        userUpdated: json["user_updated"] == null
            ? null
            : UserModel.fromJson(json["user_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "date_updated": dateUpdated?.toIso8601String(),
        "content": content,
        "attachment": attachment,
        "patient": patient,
        "user_created": userCreated?.toJson(),
        "user_updated": userUpdated?.toJson(),
      };
}
