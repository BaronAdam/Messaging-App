import 'package:messaging_app_flutter/api/objects/user.dart';

class MembersAndFriends {
  final List<User> friends;
  final List<int> members;

  MembersAndFriends(this.friends, this.members);
}
