// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

import 'package:winhealth_admin_v2/models/role.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? firstName;
  String? emailAddress;
  String? lastName;
  String? phoneNumber;
  String? email;
  DateTime? dob;
  String? gender;
  String? avatar;
  bool? pregnant;
  String? diet;
  String? height;
  Roles? access;
  String? weight;
  String? authType;
  dynamic bio;
  String? role;
  String? id;
  String? status;
  dynamic title;
  DateTime? registrationYear;
  dynamic doctorType;
  dynamic license;
  bool? appFormAanswered;
  String? exerciseType;

  UserModel(
      {this.firstName,
      this.emailAddress,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.dob,
      this.gender,
      this.avatar,
      this.pregnant,
      this.diet,
      this.height,
      this.access,
      this.weight,
      this.authType,
      this.bio,
      this.role,
      this.id,
      this.status,
      this.title,
      this.registrationYear,
      this.doctorType,
      this.license,
      this.appFormAanswered,
      this.exerciseType});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["first_name"] ?? "",
      emailAddress: json["email_address"],
      lastName: json["last_name"] ?? "",
      phoneNumber: json["phone_number"],
      email: json["email"],
      dob: json["dob"] == null ? DateTime.now() : DateTime.parse(json["dob"]),
      gender: json["gender"],
      avatar: json["avatar"],
      access: json["access"].runtimeType == String || json["access"] == null
          ? null
          : Roles.fromJson(json['access']),
      pregnant: json["pregnant"],
      diet: json["diet"],
      height: json["height"],
      weight: json["weight"],
      authType: json["auth_type"],
      bio: json["bio"],
      role: json["role"],
      id: json["id"],
      status: json["status"],
      title: json["title"],
      registrationYear: json["registration_year"] == null
          ? null
          : DateTime.parse(json["registration_year"]),
      doctorType: json["doctor_type"],
      license: json["license"],
      appFormAanswered: json['app_form_answered'] ?? false,
      exerciseType: json['exercise_type'] ?? "Daily",
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "email_address": emailAddress,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "email": email,
        "dob": dob == null
            ? null
            : "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "avatar": avatar,
        "access": access == null ? null : access!.toJson(),
        "pregnant": pregnant,
        "diet": diet,
        "height": height,
        "weight": weight,
        "auth_type": authType,
        "bio": bio,
        "role": role,
        "id": id,
        "status": status,
        "title": title,
        "registration_year": registrationYear == null
            ? null
            : "${registrationYear!.year.toString().padLeft(4, '0')}-${registrationYear!.month.toString().padLeft(2, '0')}-${registrationYear!.day.toString().padLeft(2, '0')}",
        "doctor_type": doctorType,
        "license": license,
        "app_form_answered": appFormAanswered,
        "exercise_type": exerciseType,
      };
}
