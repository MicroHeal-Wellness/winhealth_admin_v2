// To parse this JSON data, do
//
//     final standardizedCupsModel = standardizedCupsModelFromJson(jsonString);

import 'dart:convert';

StandardizedCupsModel standardizedCupsModelFromJson(String str) => StandardizedCupsModel.fromJson(json.decode(str));

String standardizedCupsModelToJson(StandardizedCupsModel data) => json.encode(data.toJson());

class StandardizedCupsModel {
    String? id;
    String? standardizedCup;
    String? standardizedValue;
    String? standardizedUnit;

    StandardizedCupsModel({
        this.id,
        this.standardizedCup,
        this.standardizedValue,
        this.standardizedUnit,
    });

    factory StandardizedCupsModel.fromJson(Map<String, dynamic> json) => StandardizedCupsModel(
        id: json["id"],
        standardizedCup: json["standardized_cup"],
        standardizedValue: json["standardized_value"],
        standardizedUnit: json["standardized_unit"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "standardized_cup": standardizedCup,
        "standardized_value": standardizedValue,
        "standardized_unit": standardizedUnit,
    };
}
