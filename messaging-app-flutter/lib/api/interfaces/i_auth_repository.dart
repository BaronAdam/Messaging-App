import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/token.dart';

abstract class IAuthRepository {
  Future<int> login(String username, String password);
  Future<ErrorStatus> register(
    String username,
    String email,
    String name,
    String password,
  );
  Future<Token> getToken();
}
