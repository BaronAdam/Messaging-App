import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/user.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

Container displayUser(result, userId, token, context) {
  Widget child;
  if (result == '400') {
    child = Container();
    showNewDialog(
      'User not found',
      'User with specified email or login could not be found',
      DialogType.WARNING,
      context,
    );
  } else if (result == '401') {
    child = Container();
    showNewDialog(
      'Unauthorized',
      'You cannot perform this operation',
      DialogType.WARNING,
      context,
    );
  } else if (result == '500') {
    child = Container();
    showNewDialog(
      'Internal Server Error',
      'There was an server error while performing this operation',
      DialogType.WARNING,
      context,
    );
  } else {
    var decoded;

    try {
      decoded = jsonDecode(result);
    } catch (e) {
      print(e);
    }

    child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              decoded['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () async {
                String response = await User.addFriend(
                  token,
                  userId,
                  decoded['id'],
                );

                print(response);

                if (response == '200') {
                  Navigator.pop(context);
                } else if (response == '401') {
                  child = Container();
                  showNewDialog(
                    'Unauthorized',
                    'You cannot perform this operation',
                    DialogType.WARNING,
                    context,
                  );
                } else if (response == '500') {
                  child = Container();
                  showNewDialog(
                    'Internal Server Error',
                    'There was an server error while performing this operation',
                    DialogType.WARNING,
                    context,
                  );
                } else {
                  child = Container();
                  showNewDialog(
                    'Error',
                    response,
                    DialogType.WARNING,
                    context,
                  );
                }
              },
            ),
          ],
        ),
        Text(decoded['username']),
        Text(decoded['email']),
      ],
    );
  }
  return Container(
    child: child,
  );
}
