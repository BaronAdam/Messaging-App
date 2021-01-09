import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';

import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/AddFriendScreen/add_friend_screen.dart';
import 'package:messaging_app_flutter/screens/ConversationsScreen/conversation_list_future_builder.dart';

class ConversationsScreen extends StatefulWidget {
  static const String id = 'conversations_screen';

  @override
  _ConversationsScreen createState() => _ConversationsScreen();
}

class _ConversationsScreen extends State<ConversationsScreen> {
  Widget ui;
  bool isFirstTime;
  HubConnection hubConnection;
  String userId, token;

  @override
  void initState() {
    ui = ListView();
    isFirstTime = true;
    super.initState();
  }

  @override
  Future<void> dispose() async {
    Future.delayed(Duration.zero, () async {
      hubConnection.off('incomingCall');
      await hubConnection.stop();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConversationsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    userId = args.userId;
    token = args.token;
    hubConnection = args.hubConnection;

    if (isFirstTime) {
      fetchGroups();
      isFirstTime = false;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Your Chats',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: kAppColor,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AddFriendScreen.id,
                arguments: AddFriendScreenArguments(token, userId),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: kAppColor,
            ),
            onPressed: fetchGroups,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: kAppColor,
            ),
            onPressed: createGroup,
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ui,
      ),
    );
  }

  fetchGroups() {
    ui = ConversationsListFutureBuilder(userId, token, hubConnection);
    setState(() {});
  }

  void createGroup() async {
    final text = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(hintText: 'Enter new group name'),
      ],
      title: 'Create new group',
      message: 'In the box below enter a name for a new group you want to '
          'create.',
      okLabel: 'OK',
      cancelLabel: 'Cancel',
      isDestructiveAction: false,
      style: AdaptiveStyle.adaptive,
      actionsOverflowDirection: VerticalDirection.up,
    );

    if (text != null && text[0] != null) {
      var result = await Group.addGroup(userId, token, text[0]);

      checkNewGroupResponse(result, text[0]);
      fetchGroups();
    }
  }

  void checkNewGroupResponse(response, name) {
    if (response == null) {
      showNewDialog(
        'Group created',
        'Successfully created group: $name',
        DialogType.SUCCES,
        context,
      );
    } else if (response == '401') {
      showNewDialog(
        'Could not create group',
        'Wrong user account',
        DialogType.WARNING,
        context,
      );
    } else if (response == '500') {
      showNewDialog(
        'Internal server error',
        'A server error occurred while processing your request. Try again '
            'later',
        DialogType.ERROR,
        context,
      );
    } else {
      showNewDialog(
        'Group name is required',
        response,
        DialogType.WARNING,
        context,
      );
    }
  }
}
