import 'dart:convert';

import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class NoteService {
  static Future<List<Note>> fetchNotesByPatientId(String patientId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/notes?filter[patient][_eq]=$patientId&fields=user_created.*,user_updated.*,attachment.*,*&sort[]=-date_created',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<Note> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(Note.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> addNote(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/notes',
        method: 'POST',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  static Future<bool> updateNote(id, payload) async {
    print(payload);
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/notes/$id',
        method: 'PATCH',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  static Future<bool> removeNote(id) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/notes/$id',
      method: 'DELETE',
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
