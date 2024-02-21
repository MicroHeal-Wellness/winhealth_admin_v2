import 'dart:convert';

import 'package:winhealth_admin_v2/models/appointment.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class AppointmentService {
  static Future<List<Appointment>> getAppointmentsByDocterIDandDate(
      String userID, String date) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/appointments?fields=*,slot.*,slot.doctor.*,user_created.*&filter={"slot":{"date":{"_eq":"$date"}}}',
      method: 'GET',
    );
    final List<Appointment> data = [];
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(Appointment.fromJson(appointment));
      }
      return data;
    } else {
      return data;
    }
  }
}
