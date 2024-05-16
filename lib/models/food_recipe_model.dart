
import 'dart:convert';

import 'package:winhealth_admin_v2/models/ingredient_model.dart';
import 'package:winhealth_admin_v2/models/standardized_cups_model.dart';

FoodRecipeModel foodRecipeModelFromJson(String str) => FoodRecipeModel.fromJson(json.decode(str));

String foodRecipeModelToJson(FoodRecipeModel data) => json.encode(data.toJson());

class FoodRecipeModel {
    String? id;
    int? quantity;
    StandardizedCupsModel? standardizedCup;
    IngredientModel? item;

    FoodRecipeModel({
        this.id,
        this.quantity,
        this.standardizedCup,
        this.item,
    });

    factory FoodRecipeModel.fromJson(Map<String, dynamic> json) => FoodRecipeModel(
        id: json["id"],
        quantity: json["quantity"] ?? 1,
        standardizedCup: json["standardized_cup"] == null ? null : StandardizedCupsModel.fromJson(json["standardized_cup"]),
        item: json["item"] == null ? null : IngredientModel.fromJson(json["item"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "standardized_cup": standardizedCup?.toJson(),
        "item": item?.toJson(),
    };
}