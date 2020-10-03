import 'dart:convert';

import 'package:messaging_app_flutter/DTOs/members_and_admins_dto.dart';
import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/user.dart';

class AdminRepository {
  static Future<MembersAndAdminsDto> getMembersAndAdminInfo(
      userId, groupId, token) async {
    var requestMembers = await Group.getMembersForGroup(userId, groupId, token);
    var requestAdmins = await Group.getAdminsForGroup(userId, groupId, token);

    if (requestAdmins == null || requestMembers == null) return null;

    List decodedMemberIds;

    try {
      decodedMemberIds = jsonDecode(requestMembers);
    } catch (e) {
      print(e);
      return null;
    }

    List<UserForSingleDto> members = [];

    for (var memberId in decodedMemberIds) {
      var response = await User.getUser(memberId, token);

      var userFromJson;

      try {
        userFromJson = jsonDecode(response);
      } catch (e) {
        print('Error in getMembersAndAdminInfo,'
            ' jsonDecode to userForSingleDto: $e');
        return null;
      }

      members.add(UserForSingleDto.fromJson(userFromJson));
    }

    List<int> adminIds = [];

    try {
      List decoded = jsonDecode(requestAdmins);

      for (var item in decoded) {
        adminIds.add(item);
      }
    } catch (e) {
      print('Error in getMembersAndAdminInfo, converting adminIds: $e');
      return null;
    }

    return MembersAndAdminsDto(members, adminIds);
  }
}
