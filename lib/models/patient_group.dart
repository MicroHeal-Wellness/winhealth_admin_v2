// To parse this JSON data, do
//
//     final patientGroup = patientGroupFromJson(jsonString);

import 'dart:convert';

PatientGroup patientGroupFromJson(String str) => PatientGroup.fromJson(json.decode(str));

String patientGroupToJson(PatientGroup data) => json.encode(data.toJson());

class PatientGroup {
    String? id;
    String? status;
    String? userCreated;
    DateTime? dateCreated;
    String? userUpdated;
    DateTime? dateUpdated;
    String? name;
    String? partner;

    PatientGroup({
        this.id,
        this.status,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.name,
        this.partner,
    });

    factory PatientGroup.fromJson(Map<String, dynamic> json) => PatientGroup(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null ? null : DateTime.parse(json["date_updated"]),
        name: json["name"],
        partner: json["partner"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "name": name,
        "partner": partner,
    };
}
