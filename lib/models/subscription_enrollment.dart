import 'dart:convert';

import 'package:winhealth_admin_v2/models/payment_model.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';

SubscriptionEnrollment subscriptionEnrollmentFromJson(String str) =>
    SubscriptionEnrollment.fromJson(json.decode(str));

String subscriptionEnrollmentToJson(SubscriptionEnrollment data) =>
    json.encode(data.toJson());

class SubscriptionEnrollment {
  String? id;
  DateTime? dateCreated;
  String? userUpdated;
  DateTime? dateUpdated;
  DateTime? validTill;
  String? transactionId;
  String? source;
  int? amount;
  int? amountPaid;
  DateTime? startDay;
  DateTime? endDay;
  DateTime? freeTill;
  bool? askPaymentLater;
  String? status;
  List<Payments>? payments;
  Plan? plan;
  UserModel? userCreated;
  UserModel? patient;

  SubscriptionEnrollment({
    this.id,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.validTill,
    this.transactionId,
    this.source,
    this.amount,
    this.amountPaid,
    this.startDay,
    this.endDay,
    this.freeTill,
    this.askPaymentLater,
    this.status,
    this.payments,
    this.plan,
    this.userCreated,
    this.patient,
  });

  factory SubscriptionEnrollment.fromJson(Map<String, dynamic> json) =>
      SubscriptionEnrollment(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        validTill: json["valid_till"] == null
            ? null
            : DateTime.parse(json["valid_till"]),
        transactionId: json["transaction_id"],
        source: json["source"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        startDay: json["start_day"] == null
            ? null
            : DateTime.parse(json["start_day"]),
        endDay:
            json["end_day"] == null ? null : DateTime.parse(json["end_day"]),
        freeTill: json["free_till"] == null
            ? null
            : DateTime.parse(json["free_till"]),
        askPaymentLater: json["ask_payment_later"],
        status: json["status"],
        payments: json["payments"] == null
            ? []
            : List<Payments>.from(json["payments"]!
                .map((x) => Payments.fromJson(x["payments_id"]))),
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
        userCreated: json["user_created"] == null
            ? null
            : UserModel.fromJson(json["user_created"]),
        patient: json["patient"] == null
            ? null
            : UserModel.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "valid_till": validTill?.toIso8601String(),
        "transaction_id": transactionId,
        "source": source,
        "amount": amount,
        "amount_paid": amountPaid,
        "start_day":
            "${startDay!.year.toString().padLeft(4, '0')}-${startDay!.month.toString().padLeft(2, '0')}-${startDay!.day.toString().padLeft(2, '0')}",
        "end_day":
            "${endDay!.year.toString().padLeft(4, '0')}-${endDay!.month.toString().padLeft(2, '0')}-${endDay!.day.toString().padLeft(2, '0')}",
        "free_till":
            "${freeTill!.year.toString().padLeft(4, '0')}-${freeTill!.month.toString().padLeft(2, '0')}-${freeTill!.day.toString().padLeft(2, '0')}",
        "ask_payment_later": askPaymentLater,
        "status": status,
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
        "plan": plan?.toJson(),
        "user_created": userCreated?.toJson(),
        "patient": patient?.toJson(),
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
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
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
