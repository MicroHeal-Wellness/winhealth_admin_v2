import 'package:winhealth_admin_v2/models/food_recipe_model.dart';

class FoodItemModel {
  String? id;
  String? userCreated;
  DateTime? dateCreated;
  dynamic userUpdated;
  dynamic dateUpdated;
  String? name;
  String? cookingInstructions;
  String? specialNotes;
  List<FoodRecipeModel>? ingredients;

  FoodItemModel({
    this.id,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.name,
    this.cookingInstructions,
    this.specialNotes,
    this.ingredients,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) => FoodItemModel(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        name: json["name"],
        cookingInstructions: json["cooking_instructions"],
        specialNotes: json["special_notes"],
        ingredients: json["ingredients"] == null
            ? []
            : List<FoodRecipeModel>.from(json["ingredients"]!.map(
                (x) => FoodRecipeModel.fromJson(x["food_recipe_item_id"]))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "name": name,
        "cooking_instructions": cookingInstructions,
        "special_notes": specialNotes,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
      };
}
