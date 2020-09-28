import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth {
  static Future<String> login(login, password) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/');

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "username": login,
          "password": password,
        },
      ),
    );

    if (response.statusCode != 200) return null;

    var token = jsonDecode(response.body)['token'];

    return token;
  }

  static Future<bool> register(login, password, email, name) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/register');

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "username": login,
          "email": email,
          "password": password,
          "name": name,
        },
      ),
    );

    print(response.statusCode);

    if (response.statusCode != 200) return false;

    return true;
  }
}
