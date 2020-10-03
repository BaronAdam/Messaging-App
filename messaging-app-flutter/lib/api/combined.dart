import 'dart:convert';

import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/user.dart';

class Combined {
  static Future<String> getFriendsAndGroupInfo(userId, groupId, token) async {
    var requestUser = await User.getFriends(userId, token);
    var requestGroup = await Group.getMembersForGroup(userId, groupId, token);

    if (requestGroup == null || requestUser == null) return null;

    return jsonEncode({
      'friends': requestUser,
      'members': requestGroup,
    });
  }
}
