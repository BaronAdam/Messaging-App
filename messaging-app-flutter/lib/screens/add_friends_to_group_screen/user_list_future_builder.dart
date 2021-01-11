import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/DTOs/member_and_friends_dto.dart';
import 'package:messaging_app_flutter/api/repositories/group_repository.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/add_friends_to_group_screen/user_card_builder.dart';

class UserListFutureBuilder extends StatelessWidget {
  final userId;
  final groupId;
  final token;

  UserListFutureBuilder(this.userId, this.groupId, this.token);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GroupRepository.getFriendsAndMembers(
        userId,
        groupId,
        token,
      ),
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
                  Text('There was an error while processing your request.'),
                ],
              );
            }
            return buildFriendsList(
                snapshot.data, userId, groupId, token, context);
        }
      },
    );
  }

  ListView buildFriendsList(
      MembersAndFriendsDto data, userId, groupId, token, context) {
    List<Widget> list = [];

    for (var friend in data.friends) {
      list.add(
        UserCardBuilder(friend, userId, groupId, token, data.members),
      );
    }

    return ListView(
      children: list,
    );
  }
}
