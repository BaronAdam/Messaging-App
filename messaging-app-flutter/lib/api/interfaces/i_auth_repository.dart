import 'package:injectable/injectable.dart';

import 'package:messaging_app_flutter/api/objects/token.dart';

@injectable
abstract class IAuthRepository {
  Future<int> login(String username, String password);
  Future<int> register(
    String username,
    String email,
    String name,
    String password,
  );
  Future<Token> getToken();
}
