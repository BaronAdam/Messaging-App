import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;

class Messages {
  static Future<String> getChats(userId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/messages');

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) return null;

    return response.body;
  }
}
