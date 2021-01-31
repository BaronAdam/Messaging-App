import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/member_and_friends.dart';
import 'package:messaging_app_flutter/api/objects/members_and_admins.dart';

abstract class IGroupRepository {
  Future<ErrorStatus> addGroup(String name);
  Future<ErrorStatus> changeGroupName(int groupId, String name);
  Future<List<int>> getMembersForGroup(int groupId);
  Future<List<int>> getAdminsForGroup(int groupId);
  Future<ErrorStatus> addMembersToGroup(int groupId, List<int> userIds);
  Future<ErrorStatus> changeAdminStatus(int groupId, int memberId);
}
