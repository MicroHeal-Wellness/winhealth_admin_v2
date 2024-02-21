import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';

class BaseService {
  // ignore: constant_identifier_names
  static const BASE_URL = "https://api.winhealth.agpro.co.in";
  // static const BASE_URL = "http://localhost:3001";
  static final Map<String, String> headers = {
    "Content-Type": "application/json"
  };

  static Map<String, dynamic> authDetails = {};

  static Future<http.Response> makeUnauthenticatedRequest(String url,
      {String method = 'POST',
      body,
      mergeDefaultHeader = true,
      Map<String, String>? extraHeaders}) async {
    try {
      if (kDebugMode) {
        print("$method URL: $url");
      }
      extraHeaders ??= {};
      var sentHeaders =
          mergeDefaultHeader ? {...headers, ...extraHeaders} : extraHeaders;

      switch (method) {
        case 'POST':
          body ??= {};
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);

        case 'GET':
          return http.get(Uri.parse(url), headers: sentHeaders);

        case 'PUT':
          return http.put(Uri.parse(url), headers: sentHeaders, body: body);

        case 'PATCH':
          return http.patch(Uri.parse(url), headers: sentHeaders, body: body);

        case 'DELETE':
          return http.delete(Uri.parse(url), headers: sentHeaders, body: body);

        default:
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.Response> makeAuthenticatedRequest(String url,
      {String method = 'POST',
      body,
      mergeDefaultHeader = true,
      Map<String, String>? extraHeaders}) async {
    try {
      if (kDebugMode) {
        print("$method URL: $url");
      }
      Map<String, dynamic> auth = await getSavedAuth();
      await refreshAuth();
      var sentHeaders = mergeDefaultHeader
          ? {
              ...BaseService.headers,
              "Authorization": "Bearer ${auth['access_token']}"
            }
          : extraHeaders;
      switch (method) {
        case 'POST':
          body ??= {};
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);

        case 'GET':
          return http.get(Uri.parse(url), headers: sentHeaders);

        case 'PUT':
          return http.put(Uri.parse(url), headers: sentHeaders, body: body);

        case 'PATCH':
          return http.patch(Uri.parse(url), headers: sentHeaders, body: body);

        case 'DELETE':
          return http.delete(Uri.parse(url), headers: sentHeaders);

        default:
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.StreamedResponse> authenticatedFileUpload(
      PlatformFile file) async {
    try {
      if (kDebugMode) {
        print(
            "authenticatedFileUpload ${file.name} of size : ${file.size} bytes");
      }
      Map<String, dynamic> auth = await getSavedAuth();
      await refreshAuth();
      var sentHeaders = {
        "Authorization": "Bearer ${auth['access_token']}",
        "Content-Type": "multipart/form-data"
      };

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse("$BASE_URL/files"));

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!.toList(),
          filename: file.name,
        ),
      );
      request.fields.addAll({"type": "image/png"});
      request.headers.addAll(sentHeaders);
      return await request.send();
    } catch (err) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getSavedAuth() async {
    if (authDetails.isNotEmpty) {
      // if (kDebugMode) {
      //   print(authDetails);
      // }
      return authDetails;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> auth = prefs.getString("auth") != null
        ? json.decode(prefs.getString("auth")!)
        : {};

    authDetails = auth;
    return auth;
  }

  static Future<UserModel?> getCurrentUser() async {
    // if (kDebugMode) {
    //   print(
    //       "------------------------------getCurrentUser called----------------------");
    // }
    Map<String, dynamic> auth = await getSavedAuth();
    // if (kDebugMode) {
    //   print("auth['user'] -> ${auth['user']}");
    // }
    return auth.isEmpty ? null : UserModel.fromJson(auth['user']);
  }

  static saveToken(
      String accessToken, String refreshToken, dynamic user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authDetails = {
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "expires_in": DateTime.now()
          .add(const Duration(seconds: 990))
          .millisecondsSinceEpoch
          .toString(),
      "user": user,
    };
    // if (kDebugMode) {
    //   print('saving authDetails: $authDetails');
    // }
    await prefs.setString(
      "auth",
      json.encode(authDetails),
    );
    await prefs.setBool(
      "isLogin",
      true,
    );
  }

  static Future refreshAuth() async {
    DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(int.parse(
        authDetails['expires_in'] ??
            DateTime.now()
                .subtract(const Duration(seconds: 10))
                .millisecondsSinceEpoch
                .toString()));
    if (expiresAt.isAfter(DateTime.now())) {
      if (kDebugMode) {
        print("---- token is not expired yet ----");
      }
      return;
    } else {
      if (kDebugMode) {
        print("---- token is expired ----");
      }
      var payload = json.encode({
        'refresh_token': authDetails['refresh_token'],
      });
      if (kDebugMode) {
        print(payload);
      }
      http.Response response = await BaseService.makeUnauthenticatedRequest(
        '${BaseService.BASE_URL}/auth/refresh',
        body: payload,
        method: 'POST',
        extraHeaders: {},
      );
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (kDebugMode) {
        print(responseMap);
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("---- token refreshed ----");
        }
        await getCurrentUser().then((UserModel? value) async {
          await saveToken(
            responseMap['data']['access_token'],
            responseMap['data']['refresh_token'],
            value!.toJson(),
          );
        });
      } else {
        if (kDebugMode) {
          print(responseMap['errors']);
        }
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        var prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      }
    }
  }
}
