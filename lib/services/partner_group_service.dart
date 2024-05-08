import 'dart:convert';

import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/models/partner.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class PatientGroupService {
  static Future<List<PatientGroup>> fetchPatientGroupsByPartner(String partnerId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/patient_group?filter[partner][_eq]=$partnerId&sort[]=name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<PatientGroup> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(PatientGroup.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<List<PatientGroup>> fetchAllPatientGroups() async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/patient_group?sort[]=name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<PatientGroup> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(PatientGroup.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  // static Future<bool> addNote(payload) async {
  //   print(payload);
  //   final response = await BaseService.makeAuthenticatedRequest(
  //       '${BaseService.BASE_URL}/items/notes',
  //       method: 'POST',
  //       body: jsonEncode(payload));
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     print(response.body);
  //     return false;
  //   }
  // }

  // static Future<bool> removeNote(id) async {
  //   final response = await BaseService.makeAuthenticatedRequest(
  //     '${BaseService.BASE_URL}/items/notes/$id',
  //     method: 'DELETE',
  //   );
  //   if (response.statusCode == 204) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
