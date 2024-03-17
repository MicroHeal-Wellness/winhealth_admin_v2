// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

class Question {
  String? id;
  String? question;
  String? type;
  String? key;
  List<Choice>? choices;

  Question({
    this.id,
    this.question,
    this.type,
    this.key,
    this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        type: json["type"],
        key: json["key"],
        choices: json["choices"] == null
            ? []
            : List<Choice>.from(
                json["choices"]!.map((x) => Choice.fromJson(x['form_choice_id']))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "type": type,
        "key": key,
        "choices": choices == null
            ? []
            : List<dynamic>.from(choices!.map((x) => x.toJson())),
      };
}

class Choice {
  String? id;
  String? label;
  String? icon;

  Choice({
    this.id,
    this.label,
    this.icon,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        label: json["label"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "icon": icon,
      };
}
