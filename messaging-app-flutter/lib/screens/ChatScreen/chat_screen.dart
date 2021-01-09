import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/screens/ChatScreen/messages_builder.dart';
import 'package:signalr_client/hub_connection.dart';

import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/CallScreen/call_screen.dart';
import 'package:messaging_app_flutter/screens/SetAdminScreen/set_admin_screen.dart';
import 'package:messaging_app_flutter/screens/AddFriendsToGroupScreen/add_friends_to_group_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String messageText, userId, token, groupId, groupName;
  Widget ui;
  bool isFirstTime;
  HubConnection hubConnection;

  @override
  void initState() {
    ui = Container();
    isFirstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;
    token = args.token;
    userId = args.userId;
    groupId = args.groupId;
    groupName = args.groupName;
    bool isGroup = args.isGroup;
    hubConnection = args.hubConnection;

    if (isFirstTime) {
      fetchMessages();
      isFirstTime = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kAppColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          isGroup
              ? IconButton(
                  icon: Icon(
                    Icons.person_add,
                    color: kAppColor,
                  ),
                  onPressed: addFriends,
                )
              : Container(),
          isGroup
              ? IconButton(
                  icon: Icon(
                    Icons.admin_panel_settings,
                    color: kAppColor,
                  ),
                  onPressed: setAdmins,
                )
              : Container(),
          isGroup
              ? IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: kAppColor,
                  ),
                  onPressed: () {
                    editGroup();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: kAppColor,
                  ),
                  onPressed: callUser,
                ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: kAppColor,
            ),
            onPressed: () async {
              fetchMessages();
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ui,
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.photo,
                      color: kAppColor,
                    ),
                    onPressed: sendImage,
                  ),
                  IconButton(
                    onPressed: sendText,
                    icon: Icon(
                      Icons.send,
                      color: kAppColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addFriends() {
    Navigator.pushNamed(
      context,
      AddFriendsToGroupScreen.id,
      arguments:
          AddFriendsToGroupScreenArguments(token, userId, groupId, groupName),
    );
  }

  void setAdmins() {
    Navigator.pushNamed(
      context,
      SetAdminScreen.id,
      arguments: SetAdminScreenArguments(token, userId, groupId, groupName),
    );
  }

  Future editGroup() async {
    final text = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(hintText: 'Enter new group name'),
      ],
      title: 'Change group name',
      message: 'In the box below enter a new name for this group.',
      okLabel: 'OK',
      cancelLabel: 'Cancel',
      isDestructiveAction: false,
      style: AdaptiveStyle.adaptive,
      actionsOverflowDirection: VerticalDirection.up,
    );

    if (text != null && text[0] != null) {
      var result = await Group.editGroupName(userId, token, groupId, text[0]);

      if (!result)
        showNewDialog(
          'Error',
          'An error occurred while changing group name',
          DialogType.WARNING,
          context,
        );
      else
        showNewDialog(
          'Changed name',
          'Group name was successfully changed',
          DialogType.SUCCES,
          context,
        );
    }
  }

  void callUser() async {
    var response = await Group.getMembersForGroup(userId, groupId, token);

    if (response == null) {
      showNewDialog(
        'Error',
        'There was an error while processing your request',
        DialogType.WARNING,
        context,
      );
      return;
    }

    var decoded;

    try {
      decoded = jsonDecode(response);
    } catch (e) {
      showNewDialog(
        'Error',
        'There was an error while processing your request',
        DialogType.WARNING,
        context,
      );
      return;
    }

    if (hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
    }

    var calleeId = decoded[0].toString() == userId ? decoded[1] : decoded[0];

    Navigator.pushNamed(
      context,
      CallScreen.id,
      arguments: CallScreenArguments(
        calleeId.toString(),
        groupName,
        hubConnection,
        false,
      ),
    );
  }

  void sendImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path);
      await Messages.sendPhotoMessage(
        userId,
        groupId,
        file.path,
        token,
      );

      fetchMessages();
    }
  }

  void sendText() async {
    if (messageText == '' || messageText == null) return;

    messageTextController.clear();
    await Messages.sendTextMessage(
      userId,
      groupId,
      messageText,
      token,
    );

    var response = await Messages.getMessagesForGroup(
      userId,
      groupId,
      token,
    );

    if (response == null) {
      showNewDialog(
        'Error',
        'There was an error while processing your request',
        DialogType.WARNING,
        context,
      );
      return;
    }

    fetchMessages();
  }

  void fetchMessages() {
    ui = MessagesBuilder(userId, groupId, token);
    setState(() {});
  }
}
