import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/constants/strings.dart';

class TimeService {
  static final _client = http.Client();

  static Future<Map<String, dynamic>> getTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var response = await _client.get(
      Uri.parse(
        apiUrl + '/times',
      ),
      headers: {
        'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
        'content-type': 'application/json',
      },
    );
    return response.statusCode == 200 ? json.decode(response.body) : {};
  }
}
