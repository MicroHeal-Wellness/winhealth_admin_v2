// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

List<Answer> answerFromJson(String str) => List<Answer>.from(json.decode(str).map((x) => Answer.fromJson(x)));

String answerToJson(List<Answer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Answer {
    int? questionKey;
    String? patientId;
    DateTime? responseDate;
    List<String>? response;
    String? others;

    Answer({
        this.questionKey,
        this.patientId,
        this.responseDate,
        this.response,
        this.others,
    });

    factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        questionKey: json["question_key"],
        patientId: json["patient_id"],
        responseDate: json["response_date"] == null ? null : DateTime.parse(json["response_date"]),
        response: json["response"] == null ? [] : List<String>.from(json["response"]!.map((x) => x)),
        others: json["others"],
    );

    Map<String, dynamic> toJson() => {
        "question_key": questionKey,
        "patient_id": patientId,
        "response_date": "${responseDate!.year.toString().padLeft(4, '0')}-${responseDate!.month.toString().padLeft(2, '0')}-${responseDate!.day.toString().padLeft(2, '0')}",
        "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x)),
        "others": others,
    };
}
