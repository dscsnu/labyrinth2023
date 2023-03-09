import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/constants/strings.dart';

class BeaconService {
  static final _client = http.Client();

  static Future<Map<String, dynamic>> getCurrentBeacons() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var response = await _client.get(
      Uri.parse(
        apiUrl + '/beacons/current',
      ),
      headers: {
        'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
        'content-type': 'application/json',
      },
    );
    return response.statusCode == 200 ? json.decode(response.body) : {};
  }

  static Future<bool> scanIsValid(String qrToken) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var response = await _client.post(
      Uri.parse(apiUrl + '/beacons/scan'),
      body: jsonEncode(
        {
          'token': qrToken,
        },
      ),
      headers: {
        'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
        'content-type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<String> getHint() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var response = await _client.get(
      Uri.parse(apiUrl + '/beacons/hint'),
      headers: {
        'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
        'content-type': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 402:
        return 'Payment required.';
      case 404:
        return 'No hint available.';
      case 200:
        return 'ok';
      default:
        return "";
    }
  }
}
