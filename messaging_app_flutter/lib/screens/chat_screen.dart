import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

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
    String _token = args.token;
    String _userId = args.userId;
    String _groupId = args.groupId;
    String _groupName = args.groupName;
    bool _isGroup = args.isGroup;

    if (isFirstTime) {
      ui = MessagesBuilder(_userId, _groupId, _token);
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
        var result =
            await Group.editGroupName(_userId, _token, _groupId, text[0]);

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
          _groupName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          _isGroup
              ? IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AddFriendsToGroupScreen.id,
                      arguments: AddFriendsToGroupScreenArguments(
                          _token, _userId, _groupId, _groupName),
                    );
                  },
                )
              : Container(),
          _isGroup
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    editGroup();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {},
                ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var response = await Messages.getMessagesForGroup(
                _userId,
                _groupId,
                _token,
              );

              ui = buildChats(_userId, response);
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
                  FlatButton(
                    onPressed: () async {
                      messageTextController.clear();
                      var result = await Messages.sendTextMessage(
                        _userId,
                        _groupId,
                        messageText,
                        _token,
                      );

                      var response = await Messages.getMessagesForGroup(
                        _userId,
                        _groupId,
                        _token,
                      );

                      ui = buildChats(_userId, response);
                      setState(() {});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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
    ));
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
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
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
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
