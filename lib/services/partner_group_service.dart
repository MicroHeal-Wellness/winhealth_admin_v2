import 'dart:convert';

import 'package:winhealth_admin_v2/components/subscription_enrollment.dart';
import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/models/partner.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class PartnerGroupService {
  static Future<List<PatientGroup>> fetchPatientGroupsByPartner(
      String partnerId) async {
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

  static Future<int> fetchPartnerGrroupPatientCount(patientGroupId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_eq":"$patientGroupId"}}]}&limit=0&meta=*',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      return respBody['meta']['filter_count'] ?? 0;
    } else {
      return 0;
    }
  }

  

  static Future<int> fetchPartnerGrroupPatientPaidSubscribedCount(patientGroupId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment?filter={"_and":[{"user_created":{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}}},{"user_created":{"patient_group":{"_eq":"$patientGroupId"}}},{"plan":{"_neq":"03dba4e5-9f43-46f7-aa23-479853993b59"}}]}&limit=0&meta=*',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      return respBody['meta']['filter_count'] ?? 0;
    } else {
      return 0;
    }
  }

  static Future<int> fetchPartnerGrroupPatientTrailSubscribedCount(patientGroupId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment?filter={"_and":[{"user_created":{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}}},{"user_created":{"patient_group":{"_eq":"$patientGroupId"}}},{"plan":{"_eq":"03dba4e5-9f43-46f7-aa23-479853993b59"}}]}&limit=0&meta=*',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      return respBody['meta']['filter_count'] ?? 0;
    } else {
      return 0;
    }
  }

  static Future<List<SubscriptionEnrollment>> fetchPartnerGrroupPatientSubcription(patientGroupId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment?filter={"_and":[{"user_created":{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}}},{"user_created":{"patient_group":{"_eq":"$patientGroupId"}}}]}&limit=-1',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<SubscriptionEnrollment> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(SubscriptionEnrollment.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

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
