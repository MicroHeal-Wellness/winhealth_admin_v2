import 'dart:convert';

import 'package:winhealth_admin_v2/models/attachment.dart';

List<Report> reportFromJson(String str) =>
    List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
  String? id;
  String? userCreated;
  DateTime? dateCreated;
  String? type;
  String? fileName;
  Attachment? file;

  Report({
    this.id,
    this.userCreated,
    this.dateCreated,
    this.type,
    this.fileName,
    this.file,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        type: json["type"],
        fileName: json["file_name"],
        file: json["file"] == null ? null : Attachment.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "type": type,
        "file_name": fileName,
        "file": file?.toJson(),
      };
}
