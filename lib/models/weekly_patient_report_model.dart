// To parse this JSON data, do
//
//     final weeklyPatientReport = weeklyPatientReportFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/user_model.dart';

List<WeeklyPatientReportModel> weeklyPatientReportFromJson(String str) =>
    List<WeeklyPatientReportModel>.from(
        json.decode(str).map((x) => WeeklyPatientReportModel.fromJson(x)));

String weeklyPatientReportToJson(List<WeeklyPatientReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeeklyPatientReportModel {
  String? id;
  UserModel? userCreated;
  DateTime? dateCreated;
  UserModel? userUpdated;
  DateTime? dateUpdated;
  int? stomachPain;
  int? stomachPainNos;
  int? acidReflux;
  int? acidRefluxNos;
  int? acidity;
  int? acidityNos;
  int? heartBurn;
  int? heartBurnNos;
  int? bloating;
  int? bloatingNos;
  int? burping;
  int? burpingNos;
  int? farting;
  int? fartingNos;
  int? constipation;
  int? constipationNos;
  int? diarrhoea;
  int? diarrhoeaNos;
  String? week;
  UserModel? patient;

  WeeklyPatientReportModel({
    this.id,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.stomachPain,
    this.stomachPainNos,
    this.acidReflux,
    this.acidRefluxNos,
    this.acidity,
    this.acidityNos,
    this.heartBurn,
    this.heartBurnNos,
    this.bloating,
    this.bloatingNos,
    this.burping,
    this.burpingNos,
    this.farting,
    this.fartingNos,
    this.constipation,
    this.constipationNos,
    this.diarrhoea,
    this.diarrhoeaNos,
    this.week,
    this.patient,
  });

  factory WeeklyPatientReportModel.fromJson(Map<String, dynamic> json) =>
      WeeklyPatientReportModel(
        id: json["id"],
        userCreated: (json["user_created"].runtimeType == String ||
                json["user_created"] == null)
            ? null
            : UserModel.fromJson(json["user_created"]),
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: (json["user_updated"].runtimeType == String ||
                json["user_updated"] == null)
            ? null
            : UserModel.fromJson(json["user_updated"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        stomachPain: json["stomach_pain"] ?? 0,
        stomachPainNos: json["stomach_pain_nos"] ?? 0,
        acidReflux: json["acid_reflux"] ?? 0,
        acidRefluxNos: json["acid_reflux_nos"] ?? 0,
        acidity: json["acidity"] ?? 0,
        acidityNos: json["acidity_nos"] ?? 0,
        heartBurn: json["heart_burn"] ?? 0,
        heartBurnNos: json["heart_burn_nos"] ?? 0,
        bloating: json["bloating"] ?? 0,
        bloatingNos: json["bloating_nos"] ?? 0,
        burping: json["burping"] ?? 0,
        burpingNos: json["burping_nos"] ?? 0,
        farting: json["farting"] ?? 0,
        fartingNos: json["farting_nos"] ?? 0,
        constipation: json["constipation"] ?? 0,
        constipationNos: json["constipation_nos"] ?? 0,
        diarrhoea: json["diarrhoea"] ?? 0,
        diarrhoeaNos: json["diarrhoea_nos"] ?? 0,
        week: json["week"],
        patient: json["patient"].runtimeType == String
            ? null
            : UserModel.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated?.toJson(),
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated?.toJson(),
        "date_updated": dateUpdated?.toIso8601String(),
        "stomach_pain": stomachPain,
        "stomach_pain_nos": stomachPainNos,
        "acid_reflux": acidReflux,
        "acid_reflux_nos": acidRefluxNos,
        "acidity": acidity,
        "acidity_nos": acidityNos,
        "heart_burn": heartBurn,
        "heart_burn_nos": heartBurnNos,
        "bloating": bloating,
        "bloating_nos": bloatingNos,
        "burping": burping,
        "burping_nos": burpingNos,
        "farting": farting,
        "farting_nos": fartingNos,
        "constipation": constipation,
        "constipation_nos": constipationNos,
        "diarrhoea": diarrhoea,
        "diarrhoea_nos": diarrhoeaNos,
        "week": week,
        "patient": patient,
      };
  Map<String, dynamic> toJsonList() => {
        "stomach_pain": stomachPain,
        "stomach_pain_nos": stomachPainNos,
        "acid_reflux": acidReflux,
        "acid_reflux_nos": acidRefluxNos,
        "acidity": acidity,
        "acidity_nos": acidityNos,
        "heart_burn": heartBurn,
        "heart_burn_nos": heartBurnNos,
        "bloating": bloating,
        "bloating_nos": bloatingNos,
        "burping": burping,
        "burping_nos": burpingNos,
        "farting": farting,
        "farting_nos": fartingNos,
        "constipation": constipation,
        "constipation_nos": constipationNos,
        "diarrhoea": diarrhoea,
        "diarrhoea_nos": diarrhoeaNos,
      };
}
