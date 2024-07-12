import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_nutrient_report_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_psyc_report_model.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class WeeklyNutrientReportService {
  static Future<List<WeeklyPatientNutrientReportModel>> fetchWeeklyNutrientReportByPatientId(
      patientId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/weekly_patient_report?filter={"patient":{"_eq":"$patientId"}}&fields=*,patient.*,user_created.*,user_updated.*',
      method: 'GET',
    );
    List<WeeklyPatientNutrientReportModel> tasks = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          WeeklyPatientNutrientReportModel activityItem =
              WeeklyPatientNutrientReportModel.fromJson(element);
          tasks.add(activityItem);
        }
        tasks.sort((a, b) {
          int? aWeekNumber = getWeekNumber(a);
          int? bWeekNumber = getWeekNumber(b);

          if (aWeekNumber == null && bWeekNumber == null) {
            return 0;
          } else if (aWeekNumber == null) {
            return 1;
          } else if (bWeekNumber == null) {
            return -1;
          } else {
            return aWeekNumber.compareTo(bWeekNumber);
          }
        });

        return tasks;
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        return [];
      }
    } else {
      return tasks;
    }
  }

  static int? getWeekNumber(WeeklyPatientNutrientReportModel obj) {
    var parts = obj.week!.toLowerCase().split(' ');
    if (parts.length == 2 && parts[0] == 'week') {
      var number = int.tryParse(parts[1]);
      if (number != null) {
        return number;
      }
    }
    return null; // Return null for invalid formats
  }

  static Future<bool> createWeeklyNutrientReport(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/weekly_patient_report',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateWeeklyNutrientReport(id, payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/weekly_patient_report/$id',
      method: 'PATCH',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
