import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth {
  static Future<String> login(login, password) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/login');

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'username': login,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return jsonDecode(response.body)['token'];
  }

  static Future<String> register(login, password, email, name) async {
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

    print(response.body);
    if (response.statusCode == 400) {
      var decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        print(e);
      }

      String errors;

      if (decoded != null) {
        decoded = decoded['errors'];
        errors = _writeRegisterErrors(decoded);
      } else {
        errors = response.body;
      }

      return errors;
    }

    if (response.statusCode == 500) return '500';

    return null;
  }

  static String _writeRegisterErrors(var decoded) {
    String toReturn = '';

    if (decoded['Email'] != null) {
      for (var element in decoded['Email']) {
        toReturn += element + '\n';
      }
    }

    if (decoded['Password'] != null) {
      for (var element in decoded['Password']) {
        toReturn += element + '\n';
      }
    }

    if (decoded['Username'] != null) {
      for (var element in decoded['Username']) {
        toReturn += element + '\n';
      }
    }

    if (decoded['Name'] != null) {
      for (var element in decoded['Name']) {
        toReturn += element + '\n';
      }
    }

    return toReturn;
  }
}
