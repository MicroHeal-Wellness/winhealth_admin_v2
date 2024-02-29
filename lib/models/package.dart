// To parse this JSON data, do
//
//     final package = packageFromJson(jsonString);

import 'dart:convert';

Package packageFromJson(String str) => Package.fromJson(json.decode(str));

String packageToJson(Package data) => json.encode(data.toJson());

class Package {
  String? id;
  String? status;
  String? userCreated;
  DateTime? dateCreated;
  dynamic userUpdated;
  dynamic dateUpdated;
  String? title;
  int? durationInDays;
  int? price;
  int? discountedPrice;
  String? features;
  String? passCode;
  bool? enableFreeTrial;
  bool? enableEnrollment;

  Package(
      {this.id,
      this.status,
      this.userCreated,
      this.dateCreated,
      this.userUpdated,
      this.dateUpdated,
      this.title,
      this.durationInDays,
      this.price,
      this.passCode,
      this.discountedPrice,
      this.features,
      this.enableFreeTrial,
      this.enableEnrollment});

  factory Package.fromJson(Map<String, dynamic> json) => Package(
      id: json["id"],
      status: json["status"],
      userCreated: json["user_created"],
      dateCreated: json["date_created"] == null
          ? null
          : DateTime.parse(json["date_created"]),
      userUpdated: json["user_updated"],
      dateUpdated: json["date_updated"],
      title: json["title"],
      durationInDays: int.parse(json["duration_in_days"]),
      price: json["price"],
      passCode: json['pass_code'],
      discountedPrice: json["discounted_price"],
      features: json["features"] ?? "",
      enableFreeTrial: json["enable_free_trial"],
      enableEnrollment: json["enable_enrollment"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "title": title,
        "pass_code": passCode,
        "duration_in_days": durationInDays,
        "price": price,
        "discounted_price": discountedPrice,
        "features": features ?? [],
        "enable_free_trial": enableFreeTrial,
        "enable_enrollment": enableEnrollment
      };
}
