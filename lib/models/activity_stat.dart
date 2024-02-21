// To parse this JSON data, do
//
//     final activityStat = activityStatFromJson(jsonString);

import 'dart:convert';

ActivityStat activityStatFromJson(String str) =>
    ActivityStat.fromJson(json.decode(str));

String activityStatToJson(ActivityStat data) => json.encode(data.toJson());

class ActivityStat {
  int? score;
  GraphData? daily;
  GraphData? weekly;
  GraphData? monthly;

  ActivityStat({
    this.score,
    this.daily,
    this.weekly,
    this.monthly,
  });

  factory ActivityStat.fromJson(Map<String, dynamic> json) => ActivityStat(
        score: json["score"],
        daily: json["daily"] == null ? null : GraphData.fromJson(json["daily"]),
        weekly:
            json["weekly"] == null ? null : GraphData.fromJson(json["weekly"]),
        monthly: json["monthly"] == null
            ? null
            : GraphData.fromJson(json["monthly"]),
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "daily": daily?.toJson(),
        "weekly": weekly?.toJson(),
        "monthly": monthly?.toJson(),
      };
}

class GraphData {
  GraphDetails? food;
  GraphDetails? water;
  GraphDetails? stool;
  GraphDetails? stress;
  GraphDetails? sleep;
  GraphDetails? constipation;
  GraphDetails? bloated;
  GraphDetails? diarrhea;
  GraphDetails? pain;

  GraphData({
    this.food,
    this.water,
    this.stool,
    this.stress,
    this.sleep,
    this.constipation,
    this.bloated,
    this.diarrhea,
    this.pain,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) => GraphData(
        food: json["food"] == null ? null : GraphDetails.fromJson(json["food"]),
        water:
            json["water"] == null ? null : GraphDetails.fromJson(json["water"]),
        stool:
            json["stool"] == null ? null : GraphDetails.fromJson(json["stool"]),
        stress: json["stress"] == null
            ? null
            : GraphDetails.fromJson(json["stress"]),
        sleep:
            json["sleep"] == null ? null : GraphDetails.fromJson(json["sleep"]),
        constipation: json["constipation"] == null
            ? null
            : GraphDetails.fromJson(json["constipation"]),
        bloated: json["bloated"] == null
            ? null
            : GraphDetails.fromJson(json["bloated"]),
        diarrhea: json["diarrhea"] == null
            ? null
            : GraphDetails.fromJson(json["diarrhea"]),
        pain: json["pain"] == null ? null : GraphDetails.fromJson(json["pain"]),
      );

  Map<String, dynamic> toJson() => {
        "food": food?.toJson(),
        "water": water?.toJson(),
        "stool": stool?.toJson(),
        "stress": stress?.toJson(),
        "sleep": sleep?.toJson(),
        "constipation": constipation?.toJson(),
        "bloated": bloated?.toJson(),
        "diarrhea": diarrhea?.toJson(),
        "pain": pain?.toJson(),
      };
}

class GraphDetails {
  String? label;
  String? duration;
  List<String>? xAxis;
  List<int>? yAxis;
  List<double>? data;

  GraphDetails({
    this.label,
    this.duration,
    this.xAxis,
    this.yAxis,
    this.data,
  });

  factory GraphDetails.fromJson(Map<String, dynamic> json) => GraphDetails(
        label: json["label"],
        duration: json["duration"],
        xAxis: json["x_axis"] == null
            ? []
            : List<String>.from(json["x_axis"]!.map((x) => x)),
        yAxis: json["y_axis"] == null
            ? []
            : List<int>.from(json["y_axis"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<double>.from(json["data"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "duration": duration,
        "x_axis": xAxis == null ? [] : List<dynamic>.from(xAxis!.map((x) => x)),
        "y_axis": yAxis == null ? [] : List<dynamic>.from(yAxis!.map((x) => x)),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
