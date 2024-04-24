import 'dart:convert';

import 'package:winhealth_admin_v2/models/answer.dart';
import 'package:winhealth_admin_v2/models/form_response.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class QuestionareService {
  static Future<bool> addFormResponse(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/form_responses',
        method: 'POST',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<FormResponse>> getAllFormAnswerByUserId(
      String userId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/form_responses?fields=*,form.*,form.questions.form_question_id.*,answers.form_answers_id.*,answers.form_answers_id.question.*,answers.form_answers_id.question.choices.form_choice_id.*&filter[patient][_eq]=$userId&sort[]=-date_created&limit=-1',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<FormResponse> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(FormResponse.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<List<QuestionForm>> getAllNonAppForms() async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/forms?fields=*,questions.form_question_id.*&filter[name][_ncontains]=App',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<QuestionForm> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(QuestionForm.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<List<FormResponse>> getFormAnswer(String userId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/form_responses?fields=*,form.*,form.questions.form_question_id.*,answers.form_answers_id.*,answers.form_answers_id.question.*,answers.form_answers_id.question.choices.form_choice_id.*&filter[patient][_eq]=$userId&filter[form][name][_icontains]=app',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<FormResponse> data = [];
      var responseJson = json.decode(response.body);
      print(responseJson);
      for (final appointment in responseJson['data']) {
        data.add(FormResponse.fromJson(appointment));
      }
      return data;
    } else {
      print(response.body);
      return [];
    }
  }
}
