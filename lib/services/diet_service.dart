import 'dart:convert';

import 'package:winhealth_admin_v2/models/diet_model.dart';
import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/food_item_model.dart';
import 'package:winhealth_admin_v2/models/ingredient_model.dart';
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

  
  static Future<bool> updateRecommendedDietGroup(id, payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/diet/$id',
      method: 'PATCH',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
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

  static Future<List<FoodItemModel>> getFoodRecipeItemsByQuery(
      String query) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/food_recipes?search=$query&fields=*,ingredients.food_recipe_item_id.*,ingredients.food_recipe_item_id.item.*',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<FoodItemModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(FoodItemModel.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<List<IngredientModel>> getFoodIngredientsByQuery(
      String query, String type) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/food_ingredients?filter[type][_eq]=$type&search=$query&sort[]=description',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      final List<IngredientModel> data = [];
      var responseJson = json.decode(response.body);
      for (final appointment in responseJson['data']) {
        data.add(IngredientModel.fromJson(appointment));
      }
      return data;
    } else {
      return [];
    }
  }

  static Future<bool> addRecipeItem(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/food_recipes',
        method: 'POST',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addDietRecipeItem(payload) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/diet_diet_item',
      method: 'POST',
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
static Future<bool> udpateDietRecipeItem(payload, id) async {
    final response = await BaseService.makeAuthenticatedRequest(
        '${BaseService.BASE_URL}/items/diet_item/$id',
        method: 'PATCH',
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeDietRecipeItem(dietId, dietItemId) async {
    final response = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/diet_diet_item?filter={"_and":[{"diet_id":{"_eq":"$dietId"}},{"diet_item_id":{"_eq":"$dietItemId"}}]}',
      method: 'GET',
    );
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      if (responseMap['data'].length == 1) {
        final response2 = await BaseService.makeAuthenticatedRequest(
          '${BaseService.BASE_URL}/items/diet_diet_item/${responseMap['data'][0]['id']}',
          method: 'DELETE',
        );
        if (response2.statusCode == 204) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
