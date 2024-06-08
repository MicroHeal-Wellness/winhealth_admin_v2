import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_report_model.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class WeeklyReportService {
  static Future<List<WeeklyPatientReportModel>> fetchWeeklyReportByPatientId(
      patientId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/weekly_patient_report?filter={"patient":{"_eq":"$patientId"}}&sort=-date_updated&fields=*,patient.*,user_created.*,user_updated.*',
      method: 'GET',
    );
    List<WeeklyPatientReportModel> tasks = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          WeeklyPatientReportModel activityItem =
              WeeklyPatientReportModel.fromJson(element);
          tasks.add(activityItem);
        }
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

  static Future<bool> createWeeklyReport(payload) async {
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

  static Future<bool> updateWeeklyReport(id, payload) async {
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
