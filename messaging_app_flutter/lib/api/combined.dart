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

  static Future<String> getMembersAndAdminInfo(userId, groupId, token) async {
    var requestMembers = await Group.getMembersForGroup(userId, groupId, token);
    var requestAdmins = await Group.getAdminsForGroup(userId, groupId, token);

    if (requestAdmins == null || requestMembers == null) return null;

    List decodedMemberIds = jsonDecode(requestMembers);

    List members = [];

    for (var memberId in decodedMemberIds) {
      members.add(await User.getUser(memberId, token));
    }

    return jsonEncode(
      {
        'users': members,
        'admins': requestAdmins,
      },
    );
  }
}
