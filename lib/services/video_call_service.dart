import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';

class VideoCallService {
  static Future<String?> getRoomCode(String roomId) async {
    final response = await BaseService.makeUnauthenticatedRequest(
      'https://api.100ms.live/v2/room-codes/room/$roomId',
      method: 'GET',
      extraHeaders: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3Nfa2V5IjoiNjU0ZDVlNjQ2ODExMWY2ZmU0YjU3Y2ZhIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJpYXQiOjE3MDU4OTg3NTksIm5iZiI6MTcwNTg5ODc1OSwiZXhwIjoxNzM3NDU2MzU5LCJqdGkiOiJlNjZjYmVlYy01MGJlLTQzYzMtODdkNi1hNmU1YmVlY2UwZjUifQ.PM5WVpnWzxkwcs_tCH6x7hKGtq5NWCze9S-jSZws0tY"
      },
    );
    var respBody = jsonDecode(response.body);
    print(respBody);
    if (response.statusCode == 200) {
      var data = respBody['data'];
      print("---------------------------------");
      print(data.firstWhere((element) => element['role'] == "doctor"));
      print(data.firstWhere((element) => element['role'] == "doctor")['code']);
      print("***&");
      if (data.firstWhere((element) => element['role'] == "doctor")['code'] ==
          null) {
        return null;
      } else {
        return data
            .firstWhere((element) => element['role'] == "doctor")['code'];
      }
    } else {
      Fluttertoast.showToast(msg: respBody['message']);
      return null;
    }
  }
}
