import 'dart:convert';

import 'package:winhealth_admin_v2/models/diet_model.dart';
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
  static Future<List<DietModel>> getRecommendedDietByPatientID(
      String patinetId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/diet?fields=*,items.diet_item_id.*,items.diet_item_id.food_item.*,items.diet_item_id.food_item.ingredients.food_recipe_item_id.*,items.diet_item_id.food_item.ingredients.food_recipe_item_id.item.*&filter[patient][_eq]=$patinetId&sort[]=name',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<DietModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(DietModel.fromJson(appointment));
      }
      // data.sort((a, b) => typeRankList[a.name].compareTo(typeRankList[b.name]));
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> addRecommendedDietGroup(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/diet',
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
      '${BaseService.BASE_URL}/items/diet/$id',
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
