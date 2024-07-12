// To parse this JSON data, do
//
//     final weeklyPatientReport = weeklyPatientReportFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/user_model.dart';

import 'dart:convert';

List<WeeklyPatientPsycReportModel> weeklyPatientPsycReportModelFromJson(String str) => List<WeeklyPatientPsycReportModel>.from(json.decode(str).map((x) => WeeklyPatientPsycReportModel.fromJson(x)));

String weeklyPatientPsycReportModelToJson(List<WeeklyPatientPsycReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeeklyPatientPsycReportModel {
    String? id;
    UserModel? userCreated;
    DateTime? dateCreated;
    UserModel? userUpdated;
    DateTime? dateUpdated;
    String? week;
    UserModel? patient;
    int? perfectionistictSelfPresentationScale;
    int? perceivedStressScale;
    int? beckAnxietyInventory;
    int? beckDepressionInventory;
    int? ibsSss;
    int? the36Qol;
    int? das21;
    int? eq5D5L;

    WeeklyPatientPsycReportModel({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.week,
        this.patient,
        this.perfectionistictSelfPresentationScale,
        this.perceivedStressScale,
        this.beckAnxietyInventory,
        this.beckDepressionInventory,
        this.ibsSss,
        this.the36Qol,
        this.das21,
        this.eq5D5L,
    });

    factory WeeklyPatientPsycReportModel.fromJson(Map<String, dynamic> json) => WeeklyPatientPsycReportModel(
        id: json["id"],
        userCreated: json["user_created"] == null ? null : UserModel.fromJson(json["user_created"]),
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"] == null ? null : UserModel.fromJson(json["user_updated"]),
        dateUpdated: json["date_updated"] == null ? null : DateTime.parse(json["date_updated"]),
        week: json["week"],
        patient: json["patient"] == null ? null : UserModel.fromJson(json["patient"]),
        perfectionistictSelfPresentationScale: json["perfectionistict_self_presentation_scale"],
        perceivedStressScale: json["perceived_stress_scale"],
        beckAnxietyInventory: json["beck_anxiety_inventory"],
        beckDepressionInventory: json["beck_depression_inventory"],
        ibsSss: json["ibs_sss"],
        the36Qol: json["36_qol"],
        das21: json["das_21"],
        eq5D5L: json["eq_5d_5l"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated?.toJson(),
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated?.toJson(),
        "date_updated": dateUpdated?.toIso8601String(),
        "week": week,
        "patient": patient?.toJson(),
        "perfectionistict_self_presentation_scale": perfectionistictSelfPresentationScale,
        "perceived_stress_scale": perceivedStressScale,
        "beck_anxiety_inventory": beckAnxietyInventory,
        "beck_depression_inventory": beckDepressionInventory,
        "ibs_sss": ibsSss,
        "36_qol": the36Qol,
        "das_21": das21,
        "eq_5d_5l": eq5D5L,
    };

    
    Map<String, dynamic> toJsonList() => {
        "perfectionistict_self_presentation_scale": "Perfectionistict Self Presentation Scale",
        "perceived_stress_scale": "Perceived Stress Scale",
        "beck_anxiety_inventory": "Beck Anxiety Inventory",
        "beck_depression_inventory": "Beck Depression Inventory",
        "ibs_sss": "IBS SSS",
        "36_qol": "36 QOL",
        "das_21": "DAS 21",
        "eq_5d_5l": "EQ 5D 5L",
    };
}