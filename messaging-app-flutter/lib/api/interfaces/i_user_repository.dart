import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/user.dart';

abstract class IUserRepository {
  Future<User> findUser(String searchPhrase);
  Future<ErrorStatus> addFriend(int friendId);
  Future<List<User>> getFriends();
  Future<User> getUser(int userId);
}