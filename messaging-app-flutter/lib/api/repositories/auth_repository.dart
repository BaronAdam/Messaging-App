import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/api/interfaces/i_auth_repository.dart';
import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/token.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final _storage = new FlutterSecureStorage();

  @override
  Future<int> login(String username, String password) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/login');

    http.Response response;

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
      return null;
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
  Future<ErrorStatus> register(
      String username, String email, String name, String password) async {
    Uri uri = Uri.http(kApiUrl, '/api/auth/register');

    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": username,
            "email": email,
            "password": password,
            "name": name,
          },
        ),
      );
    } catch (e) {
      print('Auth.register http request: $e');
      return null;
    }

    if (response.statusCode == 400) {
      return new ErrorStatus(
        _processRegisterErrors(response),
        response.statusCode,
      );
    }

    return new ErrorStatus(null, response.statusCode);
  }

  List<String> _processRegisterErrors(var response) {
    var decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      return null;
    }

    List<String> toReturn;

    if (decoded['Email'] != null) {
      toReturn.addAll(decoded['Email']);
    }

    if (decoded['Password'] != null) {
      toReturn.addAll(decoded['Password']);
    }

    if (decoded['Username'] != null) {
      toReturn.addAll(decoded['Username']);
    }

    if (decoded['Name'] != null) {
      toReturn.addAll(decoded['Name']);
    }

    return toReturn;
  }

  @override
  Future<Token> getToken() async {
    var token, userId;

    try {
      token = await _storage.read(key: 'token');
      userId = await _storage.read(key: 'id');
      if (JwtDecoder.isExpired(token)) return null;
    } catch (e) {
      return null;
    }

    return new Token(token, userId);
  }
}
