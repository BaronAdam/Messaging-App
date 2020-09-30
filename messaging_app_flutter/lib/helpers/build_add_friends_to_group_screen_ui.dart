import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/combined.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

Widget buildAddFriendsToGroupUi(userId, groupId, token) {
  return FutureBuilder(
    future: Combined.getFriendsAndGroupInfo(
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
          return buildFriendsList(
              snapshot.data, userId, groupId, token, context);
      }
    },
  );
}

ListView buildFriendsList(data, userId, groupId, token, context) {
  if (data == null) {
    return ListView(
      children: [Text('There was an error while processing your request')],
    );
  }

  var decoded = jsonDecode(data);
  var friends = jsonDecode(decoded['friends']);
  List members = jsonDecode(decoded['members']);

  List<Widget> list = [];

  for (var friend in friends) {
    list.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                friend['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              !members.contains(friend['id'])
                  ? IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        var response = await Group.addMemberToGroup(
                          userId,
                          groupId,
                          [friend['id']],
                          token,
                        );
                        if (response) {
                          showNewDialog(
                            'Success',
                            'Added ${friend['name']} to group',
                            DialogType.WARNING,
                            context,
                          );
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
                  : IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      onPressed: null,
                    ),
            ],
          ),
          Text(friend['username']),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              color: Colors.black87,
              thickness: 0.5,
            ),
          )
        ],
      ),
    );
  }

  return ListView(
    children: list,
  );
}

// if (response == '200') {
// Navigator.pop(context);
// } else if (response == '401') {
// child = Container();
// showNewDialog(
// 'Unauthorized',
// 'You cannot perform this operation',
// DialogType.WARNING,
// context,
// );
// } else if (response == '500') {
// child = Container();
// showNewDialog(
// 'Internal Server Error',
// 'There was an server error while performing this operation',
// DialogType.WARNING,
// context,
// );
// } else {
// child = Container();
// showNewDialog(
// 'Error',
// response,
// DialogType.WARNING,
// context,
// );
// }
