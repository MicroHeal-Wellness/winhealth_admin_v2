// To parse this JSON data, do
//
//     final subscription = subscriptionFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/package.dart';

Subscription subscriptionFromJson(String str) =>
    Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  String? userId;
  String? packageKey;
  DateTime? startDate;
  DateTime? expireDate;
  String? orderId;
  String? orderStatus;
  String? id;
  Package? package;
  DateTime? currentDate;
  int? currentWeek;
  int? currentDay;

  Subscription({
    this.userId,
    this.packageKey,
    this.startDate,
    this.expireDate,
    this.orderId,
    this.orderStatus,
    this.id,
    this.package,
    this.currentDate,
    this.currentWeek,
    this.currentDay,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        userId: json["user_id"],
        packageKey: json["package_key"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        expireDate: json["expire_date"] == null
            ? null
            : DateTime.parse(json["expire_date"]),
        orderId: json["order_id"],
        orderStatus: json["order_status"],
        id: json["id"],
        package:
            json["package"] == null ? null : Package.fromJson(json["package"]),
        currentDate: json["current_date"] == null
            ? null
            : DateTime.parse(json["current_date"]),
        currentWeek: json["current_week"],
        currentDay: json["current_day"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "package_key": packageKey,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "expire_date":
            "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
        "order_id": orderId,
        "order_status": orderStatus,
        "id": id,
        "package": package?.toJson(),
        "current_date":
            "${currentDate!.year.toString().padLeft(4, '0')}-${currentDate!.month.toString().padLeft(2, '0')}-${currentDate!.day.toString().padLeft(2, '0')}",
        "current_week": currentWeek,
        "current_day": currentDay,
      };
}
