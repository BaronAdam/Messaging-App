import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/api/user.dart';
import 'package:messaging_app_flutter/DTOs/user.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

class AddFriendWidgetBuilder extends StatelessWidget {
  AddFriendWidgetBuilder(
    this.decodedData,
    this.userId,
    this.token,
    this.isInFriends,
  );

  final UserForSingleDto decodedData;
  final String userId;
  final String token;
  final bool isInFriends;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              decodedData.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            isInFriends
                ? IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: null)
                : IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () async {
                      await addFriend(userId, token, decodedData, context);
                    },
                  ),
          ],
        ),
        Text(decodedData.username),
        Text(decodedData.email),
      ],
    );
  }

  Future addFriend(userId, token, decoded, context) async {
    String response = await User.addFriend(
      token,
      userId,
      decoded.id,
    );

    displayResultOfAddFriend(response, context);
  }

  void displayResultOfAddFriend(response, context) {
    if (response == '200') {
      Navigator.pop(context);
    } else if (response == '401') {
      showNewDialog(
        'Unauthorized',
        'You cannot perform this operation',
        DialogType.WARNING,
        context,
      );
    } else if (response == '500') {
      showNewDialog(
        'Internal Server Error',
        'There was an server error while performing this operation',
        DialogType.WARNING,
        context,
      );
    } else {
      showNewDialog(
        'Error',
        response,
        DialogType.WARNING,
        context,
      );
    }
  }
}
