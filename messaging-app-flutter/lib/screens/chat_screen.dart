import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/call_screen.dart';
import 'package:messaging_app_flutter/screens/set_admin_screen.dart';
import 'package:signalr_client/hub_connection.dart';

import 'add_friends_to_group_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String messageText;
  Widget ui;
  bool isFirstTime;

  @override
  void initState() {
    ui = Container();
    isFirstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args = ModalRoute.of(context).settings.arguments;
    String token = args.token;
    String userId = args.userId;
    String groupId = args.groupId;
    String groupName = args.groupName;
    bool isGroup = args.isGroup;
    HubConnection hubConnection = args.hubConnection;

    if (isFirstTime) {
      ui = MessagesBuilder(userId, groupId, token);
      isFirstTime = false;
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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AddFriendsToGroupScreen.id,
                      arguments: AddFriendsToGroupScreenArguments(
                          token, userId, groupId, groupName),
                    );
                  },
                )
              : Container(),
          isGroup
              ? IconButton(
                  icon: Icon(
                    Icons.admin_panel_settings,
                    color: kAppColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SetAdminScreen.id,
                      arguments: SetAdminScreenArguments(
                          token, userId, groupId, groupName),
                    );
                  },
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
                  onPressed: () async {
                    var response =
                        await Group.getMembersForGroup(userId, groupId, token);

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

                    if (hubConnection.state ==
                        HubConnectionState.Disconnected) {
                      await hubConnection.start();
                    }

                    var calleeId = decoded[0].toString() == userId
                        ? decoded[1]
                        : decoded[0];

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
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: kAppColor,
            ),
            onPressed: () async {
              var response = await Messages.getMessagesForGroup(
                userId,
                groupId,
                token,
              );

              ui = buildChats(userId, response);
              setState(() {});
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
                    onPressed: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles(
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

                        ui = buildChats(userId, response);
                        setState(() {});
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () async {
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

                      ui = buildChats(userId, response);
                      setState(() {});
                    },
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
}

Expanded buildChats(userId, data) {
  List<MessageBubble> messageBubbles = [];
  var decoded = jsonDecode(data);
  for (var element in decoded) {
    bool isMe = userId == element['senderId'].toString();
    messageBubbles.add(MessageBubble(
        sender: element['senderName'],
        text: element['content'],
        isMe: isMe,
        isPhoto: element['isPhoto'],
        url: element['url']));
  }

  return Expanded(
    child: ListView(
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      children: messageBubbles,
    ),
  );
}

class MessagesBuilder extends StatelessWidget {
  MessagesBuilder(this.userId, this.groupId, this.token);

  final String userId;
  final String groupId;
  final String token;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Messages.getMessagesForGroup(
        userId,
        groupId,
        token,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(
                backgroundColor: kAppColor,
              ),
            );
          default:
            if (snapshot.data == null) {
              showNewDialog(
                'Error',
                'There was an error while getting your messages',
                DialogType.WARNING,
                context,
              );
              return Container();
            }
            return buildChats(userId, snapshot.data);
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.isPhoto, this.url});

  final String sender;
  final String text;
  final bool isMe;
  final bool isPhoto;
  final String url;

  @override
  Widget build(BuildContext context) {
    String message = text == null ? '' : text;

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe ? 'You' : sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? kAppColor : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: !isPhoto
                  ? Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    )
                  : GestureDetector(
                      child: Image.network(
                        url,
                        width: 250,
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(url);
                        }));
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Image.network(
            url,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
