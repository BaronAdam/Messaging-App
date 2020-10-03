import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/DTOs/members_and_admins_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

ListView buildMembersList(
    MembersAndAdminsDto data, userId, groupId, token, context) {
  if (data == null) {
    return ListView(
      children: [Text('There was an error while processing your request.')],
    );
  }

  List<Widget> list = [];

  for (var member in data.members) {
    list.add(
      Column(
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
                icon: data.adminIds.contains(member.id)
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
                    member.id,
                    token,
                  );

                  if (result) {
                    showNewDialog(
                      'Success',
                      'Set ${member.name} as admin',
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
          Text(member.username),
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
