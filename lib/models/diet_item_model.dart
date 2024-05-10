import 'package:winhealth_admin_v2/models/food_item_model.dart';

class DietItemModel {
    String? id;
    int? quantity;
    String? specialInstruction;
    FoodItemModel? foodItem;

    DietItemModel({
        this.id,
        this.quantity,
        this.specialInstruction,
        this.foodItem,
    });

    factory DietItemModel.fromJson(Map<String, dynamic> json) => DietItemModel(
        id: json["id"],
        quantity: json["quantity"],
        specialInstruction: json["special_instruction"],
        foodItem: json["food_item"] == null ? null : FoodItemModel.fromJson(json["food_item"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "special_instruction": specialInstruction,
        "food_item": foodItem?.toJson(),
    };
}