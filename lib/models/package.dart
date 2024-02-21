// To parse this JSON data, do
//
//     final package = packageFromJson(jsonString);

import 'dart:convert';

Package packageFromJson(String str) => Package.fromJson(json.decode(str));

String packageToJson(Package data) => json.encode(data.toJson());

class Package {
    String? status;
    List<String>? description;
    int? price;
    int? discount;
    int? duration;
    String? id;
    String? name;
    String? key;

    Package({
        this.status,
        this.description,
        this.price,
        this.discount,
        this.duration,
        this.id,
        this.name,
        this.key,
    });

    factory Package.fromJson(Map<String, dynamic> json) => Package(
        status: json["status"],
        description: json["description"] == null ? [] : List<String>.from(json["description"]!.map((x) => x)),
        price: json["price"],
        discount: json["discount"],
        duration: json["duration"],
        id: json["id"],
        name: json["name"],
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "description": description == null ? [] : List<dynamic>.from(description!.map((x) => x)),
        "price": price,
        "discount": discount,
        "duration": duration,
        "id": id,
        "name": name,
        "key": key,
    };
}
