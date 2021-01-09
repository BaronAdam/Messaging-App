import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

class UserCardBuilder extends StatefulWidget {
  final UserForSingleDto friend;
  final String userId;
  final String groupId;
  final String token;
  final List<int> members;

  UserCardBuilder(
    this.friend,
    this.userId,
    this.groupId,
    this.token,
    this.members,
  );

  @override
  _UserCardBuilderState createState() =>
      _UserCardBuilderState(friend, userId, groupId, token, members);
}

class _UserCardBuilderState extends State<UserCardBuilder> {
  final UserForSingleDto friend;
  final String userId;
  final String groupId;
  final String token;
  final List<int> members;

  _UserCardBuilderState(
    this.friend,
    this.userId,
    this.groupId,
    this.token,
    this.members,
  );

  bool isntInFriends = false;

  @override
  initState() {
    isntInFriends = !members.contains(friend.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friend.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            isntInFriends
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addFriendToGroup,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: null,
                  ),
          ],
        ),
        Text(friend.username),
      ],
    );
  }

  void addFriendToGroup() async {
    var response = await Group.addMemberToGroup(
      userId,
      groupId,
      [friend.id],
      token,
    );
    if (response) {
      setState(() {
        isntInFriends = false;
      });
    } else {
      showNewDialog(
        'Error',
        'There was an error while processing your request.',
        DialogType.WARNING,
        context,
      );
    }
  }
}
