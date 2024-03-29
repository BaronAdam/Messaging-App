import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;

class User {
  static Future<String> findUser(token, input) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/find/$input');

    var response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('User.findUser http request: $e');
      return null;
    }

    if (response.statusCode != 200) return null;

    return response.body;
  }

  static Future<String> addFriend(token, userId, friendId) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/friend/$friendId');

    var response;

    try {
      response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('User.addFriend http request: $e');
      return '500';
    }

    if (response.statusCode == 400) return response.body;

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return '200';
  }

  static Future<String> getFriends(userId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/friends/$userId');

    var response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } on Exception catch (e) {
      print('User.getFriends http request: $e');
      return null;
    }

    if (response.statusCode != 200) return null;

    return response.body;
  }

  static Future<String> getUser(userId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId');

    var response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('User.getUser http request: $e');
      return null;
    }

    if (response.statusCode != 200) return null;

    return response.body;
  }
}
