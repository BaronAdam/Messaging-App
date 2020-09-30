import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/combined.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

import '../constants.dart';

Widget buildSetAdminUi(userId, groupId, token) {
  return FutureBuilder(
    future: Combined.getMembersAndAdminInfo(userId, groupId, token),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kAppColor,
            ),
          );
        default:
          return buildMembersList(
              snapshot.data, userId, groupId, token, context);
      }
    },
  );
}

ListView buildMembersList(data, userId, groupId, token, context) {
  if (data == null) {
    return ListView(
      children: [Text('There was an error while processing your request.')],
    );
  }

  var decoded = jsonDecode(data);
  List members = [];
  List admins = jsonDecode(decoded['admins']);

  for (var member in decoded['users']) {
    members.add(jsonDecode(member));
  }

  List<Widget> list = [];

  for (var member in members) {
    list.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                member['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              IconButton(
                icon: admins.contains(member['id'])
                    ? Icon(
                        Icons.remove,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                onPressed: () async {
                  var result = await Group.changeAdminStatus(
                    userId,
                    groupId,
                    member['id'],
                    token,
                  );

                  if (result) {
                    showNewDialog(
                      'Success',
                      'Set ${member['name']} as admin',
                      DialogType.SUCCES,
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
            ],
          ),
          Text(member['username']),
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
