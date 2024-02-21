// To parse this JSON data, do
//
//     final activityItem = activityItemFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';

ActivityItem activityItemFromJson(String str) =>
    ActivityItem.fromJson(json.decode(str));

String activityItemToJson(ActivityItem data) => json.encode(data.toJson());

class ActivityItem {
  String? id;
  String? userCreated;
  UserModel? addedBy;
  DateTime? dateCreated;
  dynamic response;
  String? activityType;
  DateTime? date;

  ActivityItem({
    this.id,
    this.userCreated,
    this.addedBy,
    this.dateCreated,
    this.response,
    this.activityType,
    this.date,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
        id: json["id"],
        userCreated: json["user_created"],
        addedBy: json["added_by"] == null
            ? null
            : UserModel.fromJson(json["added_by"]),
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        response: json["response"] == null
            ? null
            : mapper(json["activity_type"], json["response"]),
        activityType: json["activity_type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "added_by": addedBy,
        "date_created": dateCreated?.toIso8601String(),
        "response": response.toJson(),
        "activity_type": activityType,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

mapper(name, json) {
  switch (name) {
    case "stress":
      return json == null ? null : StressActivity.fromJson(json);
    case "water":
      return json == null ? null : WaterActivity.fromJson(json);
    case "sleep":
      return json == null ? null : SleepActivity.fromJson(json);
    case "stool":
      return json == null ? null : StoolActivity.fromJson(json);
    case "food":
      return json == null ? null : FoodActivity.fromJson(json);
    case "digestion":
      return json == null ? null : DigestionActivity.fromJson(json);
    default:
      return null;
  }
}

class DigestionActivity {
  int? constipation;
  int? bloated;
  int? diarrhea;
  int? pain;

  DigestionActivity({
    this.constipation,
    this.bloated,
    this.diarrhea,
    this.pain,
  });

  factory DigestionActivity.fromJson(Map<String, dynamic> json) =>
      DigestionActivity(
        constipation: json["constipation"],
        bloated: json["bloated"],
        diarrhea: json["diarrhea"],
        pain: json["pain"],
      );

  Map<String, dynamic> toJson() => {
        "constipation": constipation,
        "bloated": bloated,
        "diarrhea": diarrhea,
        "pain": pain,
      };
}

class FoodActivity {
  List<FoodItem>? breakfast;
  List<FoodItem>? lunch;
  List<FoodItem>? dinner;
  List<FoodItem>? others;

  FoodActivity({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.others,
  });

  factory FoodActivity.fromJson(Map<String, dynamic> json) => FoodActivity(
        breakfast: json["breakfast"] == null
            ? []
            : List<FoodItem>.from(
                json["breakfast"]!.map((x) => FoodItem.fromJson(x))),
        lunch: json["lunch"] == null
            ? []
            : List<FoodItem>.from(
                json["lunch"]!.map((x) => FoodItem.fromJson(x))),
        dinner: json["dinner"] == null
            ? []
            : List<FoodItem>.from(
                json["dinner"]!.map((x) => FoodItem.fromJson(x))),
        others: json["others"] == null
            ? []
            : List<FoodItem>.from(
                json["others"]!.map((x) => FoodItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "breakfast": breakfast == null
            ? []
            : List<dynamic>.from(breakfast!.map((x) => x.toJson())),
        "lunch": lunch == null
            ? []
            : List<dynamic>.from(lunch!.map((x) => x.toJson())),
        "dinner": dinner == null
            ? []
            : List<dynamic>.from(dinner!.map((x) => x.toJson())),
        "others": others == null
            ? []
            : List<dynamic>.from(others!.map((x) => x.toJson())),
      };
}

class SleepActivity {
  int? duration;
  int? quality;

  SleepActivity({
    this.duration,
    this.quality,
  });

  factory SleepActivity.fromJson(Map<String, dynamic> json) => SleepActivity(
        duration: json["duration"],
        quality: json["quality"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "quality": quality,
      };
}

class StoolActivity {
  int? frequency;
  dynamic formOfStoolTypes;

  StoolActivity({this.frequency, this.formOfStoolTypes});

  factory StoolActivity.fromJson(Map<String, dynamic> json) => StoolActivity(
      frequency: json["frequency"], formOfStoolTypes: json["formOfStoolTypes"]);

  Map<String, dynamic> toJson() =>
      {"frequency": frequency, "formOfStoolTypes": formOfStoolTypes};
}

class StressActivity {
  int? mood;

  StressActivity({
    this.mood,
  });

  factory StressActivity.fromJson(Map<String, dynamic> json) {
    return StressActivity(
      mood: json["mood"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mood": mood,
      };
}

class WaterActivity {
  int? quantity;

  WaterActivity({
    this.quantity,
  });

  factory WaterActivity.fromJson(Map<String, dynamic> json) => WaterActivity(
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}
