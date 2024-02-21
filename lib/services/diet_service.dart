import 'dart:convert';

import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/recommended_diet.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class DietService {
  static dynamic typeRankList = {
    'morning': 0,
    'afternoon': 1,
    'evening': 2,
    'night': 3,
  };
  static Future<List<RecommendedDiet>> getRecommendedDietByPatientID(
      String patinetId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/recommended_diet?fields=*,items.recommended_diet_item_id.*,items.recommended_diet_item_id.food_item.*,user_created.*,user_updated.*&filter[patient][_eq]=$patinetId',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<RecommendedDiet> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(RecommendedDiet.fromJson(appointment));
      }
      data.sort(
          (a, b) => typeRankList[a.type!].compareTo(typeRankList[b.type!]));
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> addRecommendedDietGroup(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/recommended_diet',
        method: 'POST',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeRecommendedDietGroup(id) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/recommended_diet/$id',
      method: 'DELETE',
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addRecommendedDietItem(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/recommended_diet_recommended_diet_item',
        method: 'POST',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> udpateRecommendedDietItem(payload, id) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/recommended_diet_recommended_diet_item/$id',
        method: 'PATCH',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeRecommendedDietItem(id) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/recommended_diet_item/$id',
      method: 'DELETE',
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<FoodItem>> getFoodItemsByQuery(String query) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/food_items?search=$query',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<FoodItem> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(FoodItem.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }
}
