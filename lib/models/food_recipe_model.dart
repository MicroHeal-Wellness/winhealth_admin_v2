import 'dart:convert';

import 'package:winhealth_admin_v2/models/ingredient_model.dart';

FoodRecipeModel foodRecipeModelFromJson(String str) => FoodRecipeModel.fromJson(json.decode(str));

String foodRecipeModelToJson(FoodRecipeModel data) => json.encode(data.toJson());

class FoodRecipeModel {
    String? id;
    int? quantity;
    String? unit;
    IngredientModel? item;

    FoodRecipeModel({
        this.id,
        this.quantity,
        this.unit,
        this.item,
    });

    factory FoodRecipeModel.fromJson(Map<String, dynamic> json) => FoodRecipeModel(
        id: json["id"],
        quantity: json["quantity"],
        unit: json["unit"],
        item: json["item"] == null ? null : IngredientModel.fromJson(json["item"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "unit": unit,
        "item": item?.toJson(),
    };
}