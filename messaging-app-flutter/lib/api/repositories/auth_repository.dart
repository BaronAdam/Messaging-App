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
      return new ErrorStatus(null, 500);
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
      for (var element in decoded['Email']) {
        toReturn.add(element);
      }
    }

    if (decoded['Password'] != null) {
      for (var element in decoded['Password']) {
        toReturn.add(element);
      }
    }

    if (decoded['Username'] != null) {
      for (var element in decoded['Username']) {
        toReturn.add(element);
      }
    }

    if (decoded['Name'] != null) {
      for (var element in decoded['Name']) {
        toReturn.add(element);
      }
    }

    return toReturn;
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

    if (JwtDecoder.isExpired(token)) return null;

    return new Token(token, userId);
  }
}
