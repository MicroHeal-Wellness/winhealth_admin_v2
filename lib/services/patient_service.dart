import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class PatientService {
  static Future<bool> createPatient(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users/',
      method: 'post',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      Fluttertoast.showToast(msg: response.body);
      return false;
    }
  }

  static Future<bool> udpatePatientGroup(
      String patientId, String? patientGroupId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users/$patientId',
      method: 'PATCH',
      body: jsonEncode({
        "patient_group": patientGroupId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<UserModel>> getUnassignedPatients(
      {int page = 1, int limit = -1}) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_null":true}}]}&fields=*,patient_group.*&limit=$limit&page=$page&sort[]=first_name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<UserModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(UserModel.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<int> getUnassignedPatientsCount() async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_null":true}}]}&fields=*,patient_group.*&limit=1&meta=filter_count&sort[]=first_name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respMap = jsonDecode(response.body);
      return int.parse(respMap['meta']['filter_count'].toString());
    } else {
      return 0;
    }
  }

  static Future<List<UserModel>> getPatients(
      {int page = 1, int limit = -1}) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter[role][_eq]=a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1&fields=*,patient_group.*&limit=$limit&page=$page&sort[]=first_name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<UserModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(UserModel.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<int> getPatientCountByPatientGroup(String patientGroup) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_eq":"$patientGroup"}}]}&fields=*,patient_group.*&limit=1&meta=filter_count&sort[]=first_name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respMap = jsonDecode(response.body);
      return int.parse(respMap['meta']['filter_count'].toString());
    } else {
      return 0;
    }
  }

  static Future<List<UserModel>> getPatientsByPatientGroup(String patientGroup,
      {int page = 1, int limit = -1}) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_eq":"$patientGroup"}}]}&fields=*,patient_group.*&limit=$limit&page=$page&sort[]=first_name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<UserModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(UserModel.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }
}
