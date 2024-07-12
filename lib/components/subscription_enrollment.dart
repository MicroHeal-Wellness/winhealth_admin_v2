// To parse this JSON data, do
//
//     final subscriptionEnrollment = subscriptionEnrollmentFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/user_model.dart';

List<SubscriptionEnrollment> subscriptionEnrollmentFromJson(String str) => List<SubscriptionEnrollment>.from(json.decode(str).map((x) => SubscriptionEnrollment.fromJson(x)));

String subscriptionEnrollmentToJson(List<SubscriptionEnrollment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionEnrollment {
    String? id;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    DateTime? validTill;
    String? transactionId;
    Plan? plan;
    UserModel? userCreated;

    SubscriptionEnrollment({
        this.id,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.validTill,
        this.transactionId,
        this.plan,
        this.userCreated,
    });

    factory SubscriptionEnrollment.fromJson(Map<String, dynamic> json) => SubscriptionEnrollment(
        id: json["id"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        validTill: json["valid_till"] == null ? null : DateTime.parse(json["valid_till"]),
        transactionId: json["transaction_id"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
        userCreated: json["user_created"] == null ? null : UserModel.fromJson(json["user_created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "valid_till": validTill?.toIso8601String(),
        "transaction_id": transactionId,
        "plan": plan?.toJson(),
        "user_created": userCreated?.toJson(),
    };
}

class Plan {
    String? id;
    String? status;
    String? userCreated;
    DateTime? dateCreated;
    String? userUpdated;
    DateTime? dateUpdated;
    String? title;
    String? durationInDays;
    int? price;
    bool? enableFreeTrial;
    int? discountedPrice;
    String? features;
    bool? enableEnrollment;
    String? passCode;

    Plan({
        this.id,
        this.status,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.title,
        this.durationInDays,
        this.price,
        this.enableFreeTrial,
        this.discountedPrice,
        this.features,
        this.enableEnrollment,
        this.passCode,
    });

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null ? null : DateTime.parse(json["date_updated"]),
        title: json["title"],
        durationInDays: json["duration_in_days"],
        price: json["price"],
        enableFreeTrial: json["enable_free_trial"],
        discountedPrice: json["discounted_price"],
        features: json["features"],
        enableEnrollment: json["enable_enrollment"],
        passCode: json["pass_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "title": title,
        "duration_in_days": durationInDays,
        "price": price,
        "enable_free_trial": enableFreeTrial,
        "discounted_price": discountedPrice,
        "features": features,
        "enable_enrollment": enableEnrollment,
        "pass_code": passCode,
    };
}