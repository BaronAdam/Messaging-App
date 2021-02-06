import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import 'package:messaging_app_flutter/api/interfaces/i_auth_repository.dart';
import 'package:messaging_app_flutter/api/interfaces/i_user_repository.dart';
import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/user.dart';
import 'package:messaging_app_flutter/constants.dart';

@Injectable(as: IUserRepository)
class UserRepository implements IUserRepository {
  IAuthRepository _authRepository;

  UserRepository(IAuthRepository authRepo) {
    _authRepository = authRepo;
  }

  @override
  Future<ErrorStatus> addFriend(int friendId) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/${token.userId}/friend/$friendId');

    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      return null;
    }

    if (response.statusCode == 400) {
      return new ErrorStatus(
        [response.body],
        response.statusCode,
      );
    }

    return new ErrorStatus(null, response.statusCode);
  }

  @override
  Future<User> findUser(String searchPhrase) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/find/$searchPhrase');

    http.Response response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${token.token}',
        },
      );
    } catch (e) {
      print('User.findUser http request: $e');
      return null;
    }

    if (response.statusCode == 200) {
      try {
        return User.fromJson(
          jsonDecode(response.body),
        );
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  @override
  Future<List<User>> getFriends() async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/friends/${token.userId}');

    http.Response response;

    try {
      response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${token.token}',
        },
      );
    } catch (e) {
      return null;
    }

    if (response.statusCode != 200) return null;

    return decodeFriends(response);
  }

  List<User> decodeFriends(http.Response response) {
    List<User> friends;

    try {
      var decoded = jsonDecode(response.body);

      for (var item in decoded) {
        friends.add(User.fromJson(item));
      }
    } catch (e) {
      return null;
    }

    return friends;
  }

  @override
  Future<User> getUser(int userId) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/$userId');

    http.Response response;

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

    if (response.statusCode == 200) {
      try {
        return User.fromJson(
          jsonDecode(response.body),
        );
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
