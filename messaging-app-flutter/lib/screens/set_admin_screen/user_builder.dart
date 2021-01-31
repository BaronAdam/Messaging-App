import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/DTOs/user.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

class UserBuilder extends StatefulWidget {
  final UserForSingleDto member;
  final List<int> adminIds;
  final String userId;
  final String groupId;
  final String token;

  UserBuilder(
      this.member, this.adminIds, this.userId, this.groupId, this.token);

  @override
  _UserBuilderState createState() =>
      _UserBuilderState(member, userId, groupId, token, adminIds);
}

class _UserBuilderState extends State<UserBuilder> {
  final UserForSingleDto member;
  final List<int> adminIds;
  final String userId;
  final String groupId;
  final String token;

  _UserBuilderState(
      this.member, this.userId, this.groupId, this.token, this.adminIds);

  static const removeIcon = Icon(
    Icons.remove,
    color: Colors.red,
  );

  static const addIcon = Icon(
    Icons.add,
    color: Colors.green,
  );

  bool isAdmin;
  @override
  initState() {
    isAdmin = adminIds.contains(member.id);

    super.initState();
  }

  bool isFirstTime = true;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      icon = adminIds.contains(member.id) ? removeIcon : addIcon;
      isFirstTime = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              member.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            IconButton(
              icon: icon,
              onPressed: () async {
                var result = await Group.changeAdminStatus(
                  userId,
                  groupId,
                  member.id,
                  token,
                );

                if (result) {
                  isAdmin = !isAdmin;
                  icon = isAdmin ? removeIcon : addIcon;
                  setState(() {});
                } else {
                  showNewDialog(
                    'Error',
                    'There was an error while processing your request.',
                    DialogType.WARNING,
                    context,
                  );
                }
              },
            )
          ],
        ),
        Text(member.username),
      ],
    );
  }
}
