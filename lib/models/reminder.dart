// To parse this JSON data, do
//
//     final reminder = reminderFromJson(jsonString);

import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
    DateTime? reminderCreatedAt;
    String? id;
    String? name;
    DateTime? startDate;
    DateTime? endDate;
    bool? neverEnding;
    String? userId;
    String? morningDosage;
    String? morningDosageType;
    String? afternoonDosage;
    String? afternoonDosageType;
    String? eveningDosage;
    String? eveningDosageType;
    String? nightDosage;
    String? nightDosageType;
    DateTime? createdAt;
    DateTime? updatedAt;

    Reminder({
        this.reminderCreatedAt,
        this.id,
        this.name,
        this.startDate,
        this.endDate,
        this.neverEnding,
        this.userId,
        this.morningDosage,
        this.morningDosageType,
        this.afternoonDosage,
        this.afternoonDosageType,
        this.eveningDosage,
        this.eveningDosageType,
        this.nightDosage,
        this.nightDosageType,
        this.createdAt,
        this.updatedAt,
    });

    factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        reminderCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        name: json["name"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        neverEnding: json["never_ending"],
        userId: json["user_id"],
        morningDosage: json["morning_dosage"],
        morningDosageType: json["morning_dosage_type"],
        afternoonDosage: json["afternoon_dosage"],
        afternoonDosageType: json["afternoon_dosage_type"],
        eveningDosage: json["evening_dosage"],
        eveningDosageType: json["evening_dosage_type"],
        nightDosage: json["night_dosage"],
        nightDosageType: json["night_dosage_type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "created_at": reminderCreatedAt?.toIso8601String(),
        "id": id,
        "name": name,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "never_ending": neverEnding,
        "user_id": userId,
        "morning_dosage": morningDosage,
        "morning_dosage_type": morningDosageType,
        "afternoon_dosage": afternoonDosage,
        "afternoon_dosage_type": afternoonDosageType,
        "evening_dosage": eveningDosage,
        "evening_dosage_type": eveningDosageType,
        "night_dosage": nightDosage,
        "night_dosage_type": nightDosageType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
