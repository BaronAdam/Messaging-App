import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Group {
  static Future<String> addGroup(userId, token, name) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group/add');

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'name': name,
        },
      ),
    );

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
        if (decoded['Name'] != null) {
          for (var element in decoded['Name']) {
            errors += element + '\n';
          }
        }
      } else {
        errors = response.body;
      }

      return errors;
    }

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return null;
  }
}
