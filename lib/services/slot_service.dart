import 'dart:convert';

import 'package:winhealth_admin_v2/models/slot.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class SlotService {
  static Future<List<Slot>> getSlotsByDocterID(
      String doctorId, String date) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/custom-api/slots?date=$date&doctorId=$doctorId',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<Slot> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['slots']) {
        data.add(Slot.fromJson(appointment));
      }
      data.sort((a, b) => a.startTime!.compareTo(b.startTime!));
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> updateSlotById(String id, String status) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/doctor_slots/$id',
        method: 'PATCH',
        body: jsonEncode({
          "status": status,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
