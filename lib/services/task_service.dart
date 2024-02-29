import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:winhealth_admin_v2/models/task_list.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class TaskService {
  static Future<List<Task>> fetchTasks(subsId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/tasks?filter={"_and":[{"plan":{"_eq":"$subsId"}},{"day":{"_gt":0}}]}&sort[]=day',
      method: 'GET',
    );
    List<Task> tasks = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          Task activityItem = Task.fromJson(element);
          tasks.add(activityItem);
        }
        return tasks;
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        return [];
      }
    } else {
      return tasks;
    }
  }

  static Future<List<Task>> fetchPreTasks(subsId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/tasks?filter={"_and":[{"plan":{"_eq":"$subsId"}},{"day":{"_lt":1}}]}&sort[]=day',
      method: 'GET',
    );
    List<Task> tasks = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          Task activityItem = Task.fromJson(element);
          tasks.add(activityItem);
        }
        return tasks;
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        return [];
      }
    } else {
      return tasks;
    }
  }
}
