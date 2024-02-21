// To parse this JSON data, do
//
//     final foodItem = foodItemFromJson(jsonString);

import 'dart:convert';

FoodItem foodItemFromJson(String str) => FoodItem.fromJson(json.decode(str));

String foodItemToJson(FoodItem data) => json.encode(data.toJson());

class FoodItem {
    String? id;
    String? name;
    double? energy;
    double? cho;
    double? protien;
    double? fats;
    double? fibre;
    double? ironPercentage;
    double? calciumPercentage;
    double? sodium;
    double? vitaminAPercentage;
    double? vitaminCPercentage;
    String? type;
    String? fodmapType;
    String? recomendedQuantity;
    String? recipe;

    FoodItem({
        this.id,
        this.name,
        this.energy,
        this.cho,
        this.protien,
        this.fats,
        this.fibre,
        this.ironPercentage,
        this.calciumPercentage,
        this.sodium,
        this.vitaminAPercentage,
        this.vitaminCPercentage,
        this.type,
        this.fodmapType,
        this.recomendedQuantity,
        this.recipe
    });

    factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        name: json["name"],
        energy: json["energy"].toDouble(),
        cho: json["cho"].toDouble(),
        protien: json["protien"]?.toDouble(),
        fats: json["fats"].toDouble(),
        fibre: json["fibre"]?.toDouble(),
        ironPercentage: json["iron_percentage"].toDouble(),
        calciumPercentage: json["calcium_percentage"].toDouble(),
        sodium: json["sodium"].toDouble(),
        vitaminAPercentage: json["vitamin_a_percentage"].toDouble(),
        vitaminCPercentage: json["vitamin_c_percentage"].toDouble(),
        type: json["type"],
        fodmapType: json["fodmap_type"],
        recomendedQuantity: json["recomended_quantity"],
        recipe: json["recipe"] ?? "N/A"
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "energy": energy,
        "cho": cho,
        "protien": protien,
        "fats": fats,
        "fibre": fibre,
        "iron_percentage": ironPercentage,
        "calcium_percentage": calciumPercentage,
        "sodium": sodium,
        "vitamin_a_percentage": vitaminAPercentage,
        "vitamin_c_percentage": vitaminCPercentage,
        "type": type,
        "fodmap_type": fodmapType,
        "recomended_quantity": recomendedQuantity,
        "recipe": recipe
    };
}
