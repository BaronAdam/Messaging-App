import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/helpers/build_conversations_ui.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/add_friend_screen.dart';

class ConversationsScreen extends StatefulWidget {
  static const String id = 'conversations_screen';

  @override
  _ConversationsScreen createState() => _ConversationsScreen();
}

class _ConversationsScreen extends State<ConversationsScreen> {
  Widget ui;
  bool isFirstTime;

  @override
  void initState() {
    ui = ListView();
    isFirstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ConversationsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    String _userId = JwtDecoder.decode(args.token)['nameid'];
    String _token = args.token;

    if (isFirstTime) {
      ui = buildConversationsUI(_userId, _token);
      isFirstTime = false;
    }

    Future createGroup() async {
      final text = await showTextInputDialog(
        context: context,
        textFields: [
          DialogTextField(hintText: 'Enter new group name'),
        ],
        title: 'Create new group',
        message:
            'In the box below enter a name for a new group you want to create.',
        okLabel: 'OK',
        cancelLabel: 'Cancel',
        isDestructiveAction: false,
        style: AdaptiveStyle.adaptive,
        actionsOverflowDirection: VerticalDirection.up,
      );

      if (text != null && text[0] != null) {
        var result = await Group.addGroup(_userId, _token, text[0]);

        if (result == null) {
          showNewDialog(
            'Group created',
            'Successfully created group: ${text[0]}',
            DialogType.SUCCES,
            context,
          );
          ui = buildConversationsUI(_userId, _token);
        } else if (result == '401') {
          showNewDialog(
            'Could not create group',
            'Wrong user account',
            DialogType.WARNING,
            context,
          );
        } else if (result == '500') {
          showNewDialog(
            'Internal server error',
            'A server error occurred while processing your request. Try again later',
            DialogType.ERROR,
            context,
          );
        } else {
          showNewDialog(
            'Group name is required',
            result,
            DialogType.WARNING,
            context,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
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
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AddFriendScreen.id,
                arguments: AddFriendScreenArguments(_token, _userId),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var result = await Messages.getChats(
                _userId,
                _token,
              );
              ui = buildListGroups(result, _userId, _token);
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await createGroup();
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ui,
        ),
      ),
    );
  }
}
