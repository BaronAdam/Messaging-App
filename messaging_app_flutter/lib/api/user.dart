import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;

class User {
  static Future<String> findUser(token, input) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/find/$input');

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 400) return '400';

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return response.body;
  }

  static Future<String> addFriend(token, userId, friendId) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/friend/$friendId');

    var response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 400) return response.body;

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return '200';
  }

  static Future<String> getFriends(userId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/friends/$userId');

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
