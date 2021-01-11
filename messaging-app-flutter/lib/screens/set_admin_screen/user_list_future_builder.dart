import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/DTOs/members_and_admins_dto.dart';
import 'package:messaging_app_flutter/api/repositories/group_repository.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/set_admin_screen/user_builder.dart';

class UserListFutureBuilder extends StatelessWidget {
  final userId;
  final groupId;
  final token;

  UserListFutureBuilder(this.userId, this.groupId, this.token);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GroupRepository.getMembersAndAdminInfo(userId, groupId, token),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kAppColor,
              ),
            );
          default:
            if (snapshot.data == null) {
              return ListView(
                children: [
                  Text('There was an error while processing your request.')
                ],
              );
            }
            return buildWidgetList(
                snapshot.data, userId, groupId, token, context);
        }
      },
    );
  }

  ListView buildWidgetList(
    MembersAndAdminsDto data,
    userId,
    groupId,
    token,
    context,
  ) {
    List<Widget> list = [];

    for (var member in data.members) {
      if (member.id == int.parse(userId)) continue;

      list.add(UserBuilder(member, data.adminIds, userId, groupId, token));
    }
    return ListView(
      children: list,
    );
  }
}
