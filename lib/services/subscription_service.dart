import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:winhealth_admin_v2/models/package.dart';
import 'package:winhealth_admin_v2/models/subscription.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/utils/date_time_utils.dart';

class SubscriptionService {
  static Future<Map> createSubscriptionOrder(
      {required Map<String, dynamic> params}) async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/orders',
      method: 'POST',
      body: jsonEncode(params),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      // throw Exception('Failed to create subscription');
      return {};
    }
  }

  static Future<bool> createTrailSubscriptionOrder(key, int days) async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment',
      method: 'POST',
      body: jsonEncode({
        "plan": key,
        "valid_till": DateTimeUtils.apiFormattedDate(
            DateTime.now().add(Duration(days: days)).toString()),
        "transaction_id": "free"
      }),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      // throw Exception('Failed to create subscription');
      return false;
    }
  }

  static Future<bool> verifyPayment(
      {required Map<String, dynamic> params}) async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/verifyPayment',
      method: 'POST',
      body: jsonEncode(params),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> capturePayment(
      {required Map<String, dynamic> params}) async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/paymentCapture',
      method: 'POST',
      body: jsonEncode(params),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Subscription>> fetchActiveSubscriptionByUserIdAndPackageId(
      userId, packageId) async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment?filter[user_created][_eq]=$userId&fields=*,plan.*&filter[plan][_eq]=$packageId',
      method: 'GET',
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<Subscription> subscriptions = [];
      for (var item in body['data']) {
        subscriptions.add(Subscription.fromJson(item));
      }
      return subscriptions;
    } else {
      throw Exception('Failed to load subscriptions');
    }
  }

  static Future<List<Subscription>> fetchActiveSubscriptionByUserId(
      userId) async {
    String today = DateFormat("yyyy-MM-dd")
        .format(DateTime.now().add(const Duration(days: 1)));
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subcription_enrollment?filter[user_created][_eq]=$userId&fields=*,plan.*&filter[valid_till][_gt]=$today',
      method: 'GET',
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<Subscription> subscriptions = [];
      for (var item in body['data']) {
        subscriptions.add(Subscription.fromJson(item));
      }
      return subscriptions;
    } else {
      throw Exception('Failed to load subscriptions');
    }
  }

  static Future<List<Package>> fetchSubscriptionPackages() async {
    http.Response res = await BaseService.makeAuthenticatedRequest(
      '${BaseService.BASE_URL}/items/subscription_plans',
      method: 'GET',
    );
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<Package> packages = [];
      for (var item in body['data']) {
        packages.add(Package.fromJson(item));
      }
      return packages;
    } else {
      throw Exception('Failed to load packages');
    }
  }
}
