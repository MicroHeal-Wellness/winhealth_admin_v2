import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:winhealth_admin_v2/models/activity.dart';
import 'package:winhealth_admin_v2/models/activity_stat.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

import '../models/food_item.dart';

class ActivityService {
  static Future<bool> addActivityUpdate(Map<String, dynamic> params) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/activity_log',
      body: jsonEncode(params),
      method: 'POST',
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
      return false;
    }
  }

  static Future<List<ActivityItem>> getActivitiesByUserIDandDate(
      String userID, String date) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/activity_log?filter={"_and":[{"user_created":"$userID"},{"date":{"_eq":"$date"}}]}&fields=*,added_by.*',
      method: 'GET',
    );
    List<ActivityItem> activityItemList = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          ActivityItem activityItem = ActivityItem.fromJson(element);
          activityItemList.add(activityItem);
        }
        if (activityItemList.isEmpty || activityItemList.length < 6) {
          var data = [];
          if (activityItemList
              .where(
                  (ActivityItem element) => (element.activityType == "water"))
              .isEmpty) {
            data.add({"activity_type": "water"});
          }
          if (activityItemList
              .where(
                  (ActivityItem element) => (element.activityType == "stool"))
              .isEmpty) {
            data.add({"activity_type": "stool"});
          }
          if (activityItemList
              .where(
                  (ActivityItem element) => (element.activityType == "stress"))
              .isEmpty) {
            data.add({"activity_type": "stress"});
          }
          if (activityItemList
              .where((ActivityItem element) => (element.activityType == "food"))
              .isEmpty) {
            data.add({"activity_type": "food"});
          }
          if (activityItemList
              .where(
                  (ActivityItem element) => (element.activityType == "sleep"))
              .isEmpty) {
            data.add({"activity_type": "sleep"});
          }
          if (activityItemList
              .where((ActivityItem element) =>
                  (element.activityType == "digestion"))
              .isEmpty) {
            data.add({"activity_type": "digestion"});
          }
          for (var element in data) {
            ActivityItem activityItem = ActivityItem.fromJson(element);
            activityItemList.add(activityItem);
          }
        }
        return activityItemList;
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        return [];
      }
    } else {
      return activityItemList;
    }
  }

  static Future<List<FoodItem>> searchNutrients(String query) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/food_items?search=$query',
      method: 'GET',
    );
    List<FoodItem> nutrients = [];
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      try {
        for (var element in responseMap['data']) {
          FoodItem activityItem = FoodItem.fromJson(element);
          nutrients.add(activityItem);
        }
        return nutrients;
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        return [];
      }
    } else {
      return nutrients;
    }
  }

  static Future<ActivityStat?> getActivitiesStatByUserID(
    String userID,
  ) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/custom-api/activity-summary?patientId=$userID',
      method: 'GET',
    );
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200 && responseMap['success']) {
      try {
        ActivityStat activityStat =
            ActivityStat.fromJson(responseMap['summary']);
        return activityStat;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> getActivityCount(String userID, String date) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/activity_log?filter={"_and":[{"user_created":"$userID"},{"date":{"_eq":"$date"}}]}&meta=*',
      method: 'GET',
    );
    var responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseMap["meta"]["filter_count"] ?? 0;
    } else {
      return 0;
    }
  }
}
