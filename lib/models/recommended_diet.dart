// To parse this JSON data, do
//
//     final recommendedDiet = recommendedDietFromJson(jsonString);

import 'dart:convert';

import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';

List<RecommendedDiet> recommendedDietFromJson(String str) =>
    List<RecommendedDiet>.from(
        json.decode(str).map((x) => RecommendedDiet.fromJson(x)));

String recommendedDietToJson(List<RecommendedDiet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedDiet {
  String? id;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? type;
  String? patient;
  List<RecommendedDietItem>? items;
  UserModel? userCreated;
  UserModel? userUpdated;

  RecommendedDiet({
    this.id,
    this.dateCreated,
    this.dateUpdated,
    this.type,
    this.patient,
    this.items,
    this.userCreated,
    this.userUpdated,
  });

  factory RecommendedDiet.fromJson(Map<String, dynamic> json) =>
      RecommendedDiet(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        type: json["type"],
        patient: json["patient"],
        items: json["items"] == null
            ? []
            : List<RecommendedDietItem>.from(json["items"]!.map((x) =>
                RecommendedDietItem.fromJson(x["recommended_diet_item_id"]))),
        userCreated: json["user_created"] == null
            ? null
            : UserModel.fromJson(json["user_created"]),
        userUpdated: json["user_updated"] == null
            ? null
            : UserModel.fromJson(json["user_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "date_updated": dateUpdated?.toIso8601String(),
        "type": type,
        "patient": patient,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "user_created": userCreated?.toJson(),
        "user_updated": userUpdated?.toJson(),
      };
}

class RecommendedDietItem {
  String? id;
  String? quantity;
  String? cookingInstruction;
  String? otherInstruction;
  FoodItem? foodItem;

  RecommendedDietItem({
    this.id,
    this.quantity,
    this.cookingInstruction,
    this.otherInstruction,
    this.foodItem,
  });

  factory RecommendedDietItem.fromJson(Map<String, dynamic> json) =>
      RecommendedDietItem(
        id: json["id"],
        quantity: json["quantity"],
        cookingInstruction: json["cooking_instruction"] ?? "N/A",
        otherInstruction: json["other_instruction"] ?? "N/A",
        foodItem: json["food_item"] == null
            ? null
            : FoodItem.fromJson(json["food_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "cooking_instruction": cookingInstruction,
        "other_instruction": otherInstruction,
        "food_item": foodItem?.toJson(),
      };
}
