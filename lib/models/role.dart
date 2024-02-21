// To parse this JSON data, do
//
//     final roles = rolesFromJson(jsonString);

import 'dart:convert';

Roles rolesFromJson(String str) => Roles.fromJson(json.decode(str));

String rolesToJson(Roles data) => json.encode(data.toJson());

class Roles {
    String? id;
    String? userCreated;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    String? title;
    List<String>? permission;

    Roles({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.title,
        this.permission,
    });

    factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        title: json["title"],
        permission: json["permission"] == null ? [] : List<String>.from(json["permission"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "title": title,
        "permission": permission == null ? [] : List<dynamic>.from(permission!.map((x) => x)),
    };
}
