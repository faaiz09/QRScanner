import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:qrscanner/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qrscanner/user_model.dart';

class Apiservice {
  Future loginRequest(String username, String password) async {
    try {
      var url = Uri.parse(ApiConstants.baseURL + ApiConstants.loginEndpoint);
      var response = await http.post(url,
          body: ({"username": username, "password": password}));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String token = data["token"];

        return data;
      } else {
        throw Exception("Failed to log in . Error : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred : $e");
    }
  }

  Future<List<UserModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseURL + ApiConstants.userInfoEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // ignore: no_leading_underscores_for_local_identifiers
        List<UserModel> _model = userModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      printToConsole(e.toString());
    }
  }
}
