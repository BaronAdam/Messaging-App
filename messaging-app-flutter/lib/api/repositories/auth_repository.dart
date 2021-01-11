import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:messaging_app_flutter/api/objects/token.dart';
import 'dart:convert';

import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/api/interfaces/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final _storage = new FlutterSecureStorage();

  @override
  Future<int> login(String username, String password) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/login');

    var response;

    try {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
    } catch (e) {
      print('Auth.login http request: $e');
      return 500;
    }

    decodeAndStoreToken(response.body);

    return response.statusCode;
  }

  void decodeAndStoreToken(String json) {
    var token;

    try {
      token = jsonDecode(json)['token'];
    } catch (e) {
      print('Auth.login jsonDecode: $e');
    }

    var id = JwtDecoder.decode(token)['nameid'];

    _storage.write(key: 'token', value: token);
    _storage.write(key: 'id', value: id.toString());
  }

  @override
  Future<int> register(
      String username, String email, String name, String password) async {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Token> getToken() async {
    var token, userId;

    try {
      token = await _storage.read(key: 'token');
      userId = await _storage.read(key: 'id');
    } catch (e) {
      return null;
    }

    return new Token(token, userId);
  }
}
