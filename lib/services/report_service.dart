import 'dart:convert';
import 'package:winhealth_admin_v2/models/report.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class ReportService {
  static Future<List<Report>> fetchReportsByPatientId(String patientId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/reports?filter[user_created][_eq]=$patientId&fields=*,file.*&sort[]=-date_created',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<Report> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(Report.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }
}
