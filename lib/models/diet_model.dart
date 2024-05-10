import 'dart:convert';

import 'package:winhealth_admin_v2/models/diet_item_model.dart';

DietModel dietModelFromJson(String str) => DietModel.fromJson(json.decode(str));

String dietModelToJson(DietModel data) => json.encode(data.toJson());

class DietModel {
    String? id;
    String? userCreated;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    String? patient;
    String? name;
    List<DietItemModel>? items;

    DietModel({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.patient,
        this.name,
        this.items,
    });

    factory DietModel.fromJson(Map<String, dynamic> json) => DietModel(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        patient: json["patient"],
        name: json["name"],
        items: json["items"] == null ? [] : List<DietItemModel>.from(json["items"]!.map((x) => DietItemModel.fromJson(x["diet_item_id"]))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "patient": patient,
        "name": name,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}