import 'package:messaging_app_flutter/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Group {
  static Future<String> addGroup(userId, token, name) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group/add');

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'name': name,
        },
      ),
    );

    if (response.statusCode == 400) {
      var decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        print(e);
      }

      String errors;

      if (decoded != null) {
        decoded = decoded['errors'];
        if (decoded['Name'] != null) {
          for (var element in decoded['Name']) {
            errors += element + '\n';
          }
        }
      } else {
        errors = response.body;
      }

      return errors;
    }

    if (response.statusCode == 401) return '401';

    if (response.statusCode == 500) return '500';

    return null;
  }

  static Future<bool> editGroupName(userId, token, groupId, name) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group');

    var response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'id': int.parse(groupId),
          'name': name,
        },
      ),
    );

    if (response.statusCode != 200) return false;

    return true;
  }

  static Future<String> getMembersForGroup(userId, groupId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group/members/id/$groupId');

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) return null;

    return response.body;
  }

  static Future<bool> addMemberToGroup(
      userId, groupId, List<int> userIds, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group/add/$groupId');

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'ids': userIds,
        }));

    print(response.body);

    if (response.statusCode != 200) return false;

    return true;
  }

  static Future<String> getAdminsForGroup(userId, groupId, token) async {
    Uri uri =
        Uri.http(kApiUrl, '/api/users/$userId/group/members/admins/$groupId');

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) return null;

    return response.body;
  }

  static Future<bool> changeAdminStatus(
      userId, groupId, memberId, token) async {
    Uri uri = Uri.http(kApiUrl, '/api/users/$userId/group/admin');

    var response = await http.patch(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': memberId,
          'groupId': int.parse(groupId),
        }));

    print(response.body);

    if (response.statusCode != 200) return false;

    return true;
  }
}

//api/users/{userId}/Group/members/admins/{groupId}
