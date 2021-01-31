import 'package:messaging_app_flutter/api/objects/user.dart';

class MembersAndAdmins {
  final List<User> members;
  final List<int> adminIds;

  MembersAndAdmins(this.members, this.adminIds);
}
