import 'package:winhealth_admin_v2/models/user_model.dart';

class Slot {
  String? id;
  String? status;
  String? startTime;
  String? endTime;
  DateTime? date;
  UserModel? doctor;

  Slot({
    this.id,
    this.status,
    this.startTime,
    this.endTime,
    this.date,
    this.doctor,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json["id"],
      status: json["status"] ?? "unavailable",
      startTime: json["start_time"],
      endTime: json["end_time"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      doctor: json["doctor"].runtimeType == String
          ? null
          : UserModel.fromJson(json["doctor"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "start_time": startTime,
        "end_time": endTime,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "doctor": doctor?.toJson(),
      };
}
