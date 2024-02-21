import 'dart:convert';
import 'package:winhealth_admin_v2/models/role.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class RoleService {
  static Future<List<Roles>> fetchAllRolls() async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/doctor_roles?sort[]=title',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<Roles> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(Roles.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> udpateRole(String id, payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/doctor_roles/$id',
      method: 'PATCH',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addRole(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/doctor_roles',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
