import 'dart:convert';

import 'package:messaging_app_flutter/DTOs/member_and_friends_dto.dart';
import 'package:messaging_app_flutter/DTOs/members_and_admins_dto.dart';
import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/user.dart';

class GroupRepository {
  static Future<MembersAndAdminsDto> getMembersAndAdminInfo(
      userId, groupId, token) async {
    var requestMembers = await Group.getMembersForGroup(userId, groupId, token);
    var requestAdmins = await Group.getAdminsForGroup(userId, groupId, token);

    if (requestAdmins == null || requestMembers == null) return null;

    List<int> decodedMemberIds = decodeIds(
      requestMembers,
      'getMembersAndAdminInfo',
    );

    List<UserForSingleDto> members = await decodeToUserForSingleDtos(
      decodedMemberIds,
      token,
      'getMembersAndAdminInfo',
    );

    List<int> adminIds = decodeIds(requestAdmins, 'getMembersAndAdminInfo');

    return MembersAndAdminsDto(members, adminIds);
  }

  static Future<List<UserForSingleDto>> decodeToUserForSingleDtos(
      decodedMemberIds, token, text) async {
    List<UserForSingleDto> members = [];

    for (var memberId in decodedMemberIds) {
      var response = await User.getUser(memberId, token);

      var userFromJson;

      try {
        userFromJson = jsonDecode(response);
      } catch (e) {
        print('GroupRepository.$text,'
            ' jsonDecode to List<UserForSingleDto>: $e');
        return null;
      }

      members.add(UserForSingleDto.fromJson(userFromJson));
    }

    return members;
  }

  static Future<MembersAndFriendsDto> getFriendsAndMembers(
      userId, groupId, token) async {
    var requestUsers = await User.getFriends(userId, token);
    var requestMembers = await Group.getMembersForGroup(userId, groupId, token);

    if (requestMembers == null || requestUsers == null) return null;

    List<UserForSingleDto> friends = [];

    try {
      var decoded = jsonDecode(requestUsers);

      for (var item in decoded) {
        friends.add(UserForSingleDto.fromJson(item));
      }
    } catch (e) {
      print('GroupRepository.getFriendsAndMembers,'
          ' jsonDecode to List<UserForSingleDto>: $e');
      return null;
    }

    List<int> memberIds = decodeIds(requestMembers, 'getFriendsAndMembers');

    return MembersAndFriendsDto(friends, memberIds);
  }

  static List<int> decodeIds(data, text) {
    List<int> ids = [];

    try {
      List decoded = jsonDecode(data);

      for (var item in decoded) {
        ids.add(item);
      }
    } catch (e) {
      print('GroupRepository.$text, converting adminIds: $e');
      return null;
    }

    return ids;
  }
}
