import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:messaging_app_flutter/api/interfaces/i_auth_repository.dart';
import 'package:messaging_app_flutter/api/interfaces/i_group_repository.dart';
import 'package:messaging_app_flutter/api/objects/error_status.dart';
import 'package:messaging_app_flutter/api/objects/member_and_friends.dart';
import 'package:messaging_app_flutter/api/objects/members_and_admins.dart';
import 'package:messaging_app_flutter/constants.dart';

@Injectable(as: IGroupRepository)
class GroupRepository implements IGroupRepository {
  IAuthRepository _authRepository;

  GroupRepository(IAuthRepository authRepo) {
    _authRepository = authRepo;
  }

  @override
  Future<ErrorStatus> addGroup(String name) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/${token.userId}/group/add');

    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.token}',
        },
        body: jsonEncode(
          {
            'name': name,
          },
        ),
      );
    } catch (e) {
      return null;
    }

    if (response.statusCode == 400) {
      return new ErrorStatus(
        decodeAddGroupErrors(response),
        response.statusCode,
      );
    }

    return new ErrorStatus(null, response.statusCode);
  }

  List<String> decodeAddGroupErrors(http.Response response) {
    var decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }

    List<String> errors;

    if (decoded != null) {
      decoded = decoded['errors'];
      if (decoded['Name'] != null) {
        errors.addAll(decoded['Name']);
      }
    } else {
      errors.add(response.body);
    }

    return errors;
  }

  @override
  Future<ErrorStatus> addMembersToGroup(int groupId, List<int> userIds) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(
      kApiUrl,
      '/api/users/${token.userId}/group/add/$groupId',
    );

    http.Response response;

    try {
      response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.token}',
          },
          body: jsonEncode({
            'ids': userIds,
          }));
    } catch (e) {
      print('Group.addMemberToGroup http request: $e');
      return null;
    }

    return new ErrorStatus(null, response.statusCode);
  }

  @override
  Future<ErrorStatus> changeAdminStatus(int groupId, int memberId) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/${token.userId}/group/admin');

    http.Response response;

    try {
      response = await http.patch(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.token}',
          },
          body: jsonEncode({
            'userId': memberId,
            'groupId': groupId,
          }));
    } catch (e) {
      print('Group.changeAdminStatus http request: $e');
      return null;
    }

    return new ErrorStatus(null, response.statusCode);
  }

  @override
  Future<ErrorStatus> changeGroupName(int groupId, String name) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(kApiUrl, '/api/users/${token.userId}/group');

    http.Response response;

    try {
      response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.token}',
        },
        body: jsonEncode(
          {
            'id': groupId,
            'name': name,
          },
        ),
      );
    } catch (e) {
      return null;
    }

    return new ErrorStatus(null, response.statusCode);
  }

  @override
  Future<List<int>> getAdminsForGroup(int groupId) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(
      kApiUrl,
      '/api/users/${token.userId}/group/members/admins/$groupId',
    );

    http.Response response;

    try {
      response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${token.token}',
      });
    } catch (e) {
      print('Group.getAdminsForGroup http request: $e');
      return null;
    }

    if (response.statusCode != 200) return null;

    return _decodeIds(response);
  }

  @override
  Future<List<int>> getMembersForGroup(int groupId) async {
    var token = await _authRepository.getToken();
    if (token == null) return null;

    Uri uri = Uri.http(
      kApiUrl,
      '/api/users/${token.userId}/group/members/id/$groupId',
    );

    http.Response response;

    try {
      response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${token.token}',
      });
    } catch (e) {
      return null;
    }

    if (response.statusCode != 200) return null;

    return _decodeIds(response);
  }

  List<int> _decodeIds(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MembersAndFriends> getFriendsAndMembers(int groupId) async {
    // TODO: implement getFriendsAndMembers
    throw UnimplementedError();
  }

  @override
  Future<MembersAndAdmins> getMembersAndAdmins(int groupId) async {
    // TODO: implement getFriendsAndAdmins
    throw UnimplementedError();
  }
}
