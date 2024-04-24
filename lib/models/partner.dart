// To parse this JSON data, do
//
//     final partner = partnerFromJson(jsonString);

import 'dart:convert';

Partner partnerFromJson(String str) => Partner.fromJson(json.decode(str));

String partnerToJson(Partner data) => json.encode(data.toJson());

class Partner {
    String? id;
    String? status;
    String? userCreated;
    DateTime? dateCreated;
    String? userUpdated;
    DateTime? dateUpdated;
    String? name;
    String? image;

    Partner({
        this.id,
        this.status,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.name,
        this.image,
    });

    factory Partner.fromJson(Map<String, dynamic> json) => Partner(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null ? null : DateTime.parse(json["date_updated"]),
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "name": name,
        "image": image,
    };
}
