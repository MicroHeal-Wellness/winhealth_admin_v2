// To parse this JSON data, do
//
//     final subscription = subscriptionFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/package.dart';

Subscription subscriptionFromJson(String str) => Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
    String? id;
    String? userCreated;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    DateTime? validTill;
    Package? plan;

    Subscription({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.validTill,
        this.plan,
    });

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        validTill: json["valid_till"] == null ? null : DateTime.parse(json["valid_till"]),
        plan: json["plan"] == null ? null : Package.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "valid_till": validTill?.toIso8601String(),
        "plan": plan?.toJson(),
    };
}
