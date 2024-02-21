// To parse this JSON data, do
//
//     final formResponse = formResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<FormResponse> formResponseFromJson(String str) => List<FormResponse>.from(
    json.decode(str).map((x) => FormResponse.fromJson(x)));

String formResponseToJson(List<FormResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormResponse {
  String? id;
  String? userCreated;
  String? patient;
  DateTime? dateCreated;
  dynamic userUpdated;
  dynamic dateUpdated;
  List<Answer>? answers;
  QuestionForm? form;

  FormResponse({
    this.id,
    this.userCreated,
    this.patient,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.answers,
    this.form,
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) => FormResponse(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        patient: json['patient'],
        answers: json["answers"] == null
            ? []
            : List<Answer>.from(
                json["answers"]!.map((x) => Answer.fromJson(x))),
        form: json["form"] == null ? null : QuestionForm.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "patient": patient,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "answers": answers == null
            ? []
            : List<dynamic>.from(answers!.map((x) => x.toJson())),
        "form": form?.toJson(),
      };
}

class Answer {
  FormAnswersId? formAnswersId;

  Answer({
    this.formAnswersId,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        formAnswersId: json["form_answers_id"] == null
            ? null
            : FormAnswersId.fromJson(json["form_answers_id"]),
      );

  Map<String, dynamic> toJson() => {
        "form_answers_id": formAnswersId?.toJson(),
      };
}

class FormAnswersId {
  String? id;
  String? userCreated;
  DateTime? dateCreated;
  dynamic userUpdated;
  dynamic dateUpdated;
  String? question;
  List<String>? response;

  FormAnswersId({
    this.id,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.question,
    this.response,
  });

  factory FormAnswersId.fromJson(Map<String, dynamic> json) {
    return FormAnswersId(
      id: json["id"],
      userCreated: json["user_created"],
      dateCreated: json["date_created"] == null
          ? null
          : DateTime.parse(json["date_created"]),
      userUpdated: json["user_updated"],
      dateUpdated: json["date_updated"],
      question: json["question"],
      response: json["response"] == null
          ? []
          : List<String>.from(jsonDecode(json["response"])!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "question": question,
        "response":
            response == null ? [] : List<dynamic>.from(response!.map((x) => x)),
      };
}

class QuestionForm {
  String? id;
  String? status;
  String? userCreated;
  DateTime? dateCreated;
  String? userUpdated;
  DateTime? dateUpdated;
  String? name;
  List<Question>? questions;

  QuestionForm({
    this.id,
    this.status,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.name,
    this.questions,
  });

  factory QuestionForm.fromJson(Map<String, dynamic> json) => QuestionForm(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        name: json["name"],
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "name": name,
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
      };
}

class Question {
  FormQuestionId? formQuestionId;

  Question({
    this.formQuestionId,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        formQuestionId: json["form_question_id"] == null
            ? null
            : FormQuestionId.fromJson(json["form_question_id"]),
      );

  Map<String, dynamic> toJson() => {
        "form_question_id": formQuestionId?.toJson(),
      };
}

class FormQuestionId {
  String? id;
  String? userCreated;
  DateTime? dateCreated;
  String? userUpdated;
  DateTime? dateUpdated;
  String? question;
  Type? type;
  String? key;
  List<int>? choices;

  FormQuestionId({
    this.id,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.question,
    this.type,
    this.key,
    this.choices,
  });

  factory FormQuestionId.fromJson(Map<String, dynamic> json) => FormQuestionId(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"] == null
            ? null
            : DateTime.parse(json["date_updated"]),
        question: json["question"],
        type: typeValues.map[json["type"]]!,
        key: json["key"],
        choices: json["choices"] == null
            ? []
            : List<int>.from(json["choices"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated?.toIso8601String(),
        "question": question,
        "type": typeValues.reverse[type],
        "key": key,
        "choices":
            choices == null ? [] : List<dynamic>.from(choices!.map((x) => x)),
      };
}

enum Type { MULTICHOICE, SINGLECHOICE, SLIDER, TEXT }

final typeValues = EnumValues({
  "multichoice": Type.MULTICHOICE,
  "singlechoice": Type.SINGLECHOICE,
  "slider": Type.SLIDER,
  "text": Type.TEXT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
