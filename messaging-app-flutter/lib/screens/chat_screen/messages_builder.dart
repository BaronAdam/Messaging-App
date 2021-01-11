import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/chat_screen/message_bubble.dart';

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
}
