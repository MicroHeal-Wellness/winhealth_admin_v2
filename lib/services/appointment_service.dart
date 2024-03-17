import 'dart:convert';

import 'package:http/http.dart';
import 'package:winhealth_admin_v2/models/appointment.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class AppointmentService {
  static Future<List<Appointment>> getAppointmentsByPatientId(
      String userID) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/appointments?fields=*,slot.*,slot.doctor.*,user_created.*,patient.*&filter={"_and":[{"cancelled_by":{"_eq":"none"}},{"patient":{"_eq":"$userID"}}]}',
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

  static Future<List<Appointment>> getAppointmentsByDateAndPatientId(
      String userID, String date) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/appointments?fields=*,slot.*,slot.doctor.*,user_created.*,patient.*&filter={"_and":[{"slot":{"date":{"_eq":"$date"}}},{"cancelled_by":{"_eq":"none"}},{"patient":{"_eq":"$userID"}}]}',
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

  static Future<bool> createApppointment(paylaod) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/appointments',
      body: jsonEncode(paylaod),
      method: 'POST',
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Appointment>> getAppointmentsByDocterIDandDate(
      String doctorId, String date) async {
    var url =
        '${BaseService.BASE_URL}/items/appointments?fields=*,slot.*,slot.doctor.*,user_created.*,patient.*&filter={"_and":[{"slot":{"date":{"_eq":"$date"}}},{"cancelled_by":{"_eq":"none"}},{"slot":{"doctor":{"_eq":"$doctorId"}}}]}';
    Response response = await BaseService.makeAuthenticatedRequest(
      url,
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<Appointment> appointments = [];
      var responseJson = json.decode(response.body);
      print(responseJson);
      for (final appointment in responseJson['data']) {
        appointments.add(Appointment.fromJson(appointment));
      }
      return appointments;
    } else {
      return [];
    }
  }
}
