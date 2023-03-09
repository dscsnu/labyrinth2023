import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/constants/strings.dart';

class AuthenticationService {
  static final teamNameRegex = RegExp(r'^(\w){4,8}$');
  static final _client = http.Client();

  static String email = "", password = "";

  static _setAuthParameters(String token) async {
    await SharedPreferences.getInstance().then(
      (pref) {
        pref.setBool('isLoggedIn', true);
        pref.setString(
          'token',
          token,
        );
      },
    );
  }

  static Future<String> login(String teamName, String password) async {
    if (teamNameRegex.hasMatch(teamName)) {
      var response = await _client.post(
        Uri.parse(apiUrl + '/teams/login'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(
          {
            'teamName': teamName,
            'password': password,
          },
        ),
      );
      if (response.statusCode == 200) {
        _setAuthParameters(json.decode(response.body)['token']);
        return 'ok';
      } else {
        return json.decode(response.body)['message'];
      }
    } else {
      return 'Password should be between 4 and 8 characters.';
    }
  }

  static Future<String> register(String teamName, String password, String email,
      List<String> names) async {
    var response = await _client.post(
      Uri.parse(apiUrl + '/teams/register'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(
        {
          'teamName': teamName,
          'password': password,
          "email": email,
          "names": names,
        },
      ),
    );
    if (response.statusCode == 201) {
      return 'ok';
    } else {
      return json.decode(response.body)['message'];
    }
  }

  static Future<String> resetRequest(String email) async {
    var response = await _client.post(
      Uri.parse(apiUrl + '/teams/reset/request'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
        },
      ),
    );
    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'error';
    }
  }

  static Future<String> reset(String code, String newPassword) async {
    if (newPassword.length < 4) {
      return 'Password length should be more than 4 characters.';
    }
    var response = await _client.post(
      Uri.parse(apiUrl + '/teams/reset'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(
        {
          'code': code,
          'password': newPassword,
        },
      ),
    );
    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return json.decode(response.body)['message'];
    }
  }
}
