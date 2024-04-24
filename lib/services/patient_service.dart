import 'dart:convert';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class PatientService {
  static Future<List<UserModel>> getPatients(
      {int page = 1, int limit = -1}) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter[role][_eq]=a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1&limit=$limit&page=$page',
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
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_eq":"$patientGroup"}}]}&limit=1&meta=filter_count',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var respMap = jsonDecode(response.body);
      return int.parse(respMap['meta']['filter_count'].toString());
    } else {
      return 0;
    }
  }

  static Future<List<UserModel>> getPatientsByPatientGroup(String patientGroup,{int page = 1, int limit = -1}) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/users?filter={"_and":[{"role":{"_eq":"a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1"}},{"patient_group":{"_eq":"$patientGroup"}}]}&limit=$limit&page=$page',
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
