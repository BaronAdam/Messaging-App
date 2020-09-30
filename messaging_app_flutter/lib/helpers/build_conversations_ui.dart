import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/screens/chat_screen.dart';

import '../constants.dart';

Widget buildConversationsUI(userId, token) {
  return FutureBuilder(
    future: Messages.getChats(
      userId,
      token,
    ),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kAppColor,
            ),
          );
        default:
          return buildListGroups(snapshot.data, userId, token);
      }
    },
  );
}

ListView buildListGroups(data, userId, token) {
  var objects = jsonDecode(data);

  List<Widget> widgets = [];

  for (var object in objects) {
    var date = DateTime.parse(object['lastSent']);

    var formattedDate;

    if (date.compareTo(DateTime.now().subtract(Duration(days: 365 * 100))) <
        0) {
      formattedDate = '';
    } else {
      formattedDate = formatDate(
        date,
        [dd, '.', mm, '.', yyyy],
      );
    }

    widgets.add(
      ContainerWithProperties(
        object: object,
        formattedDate: formattedDate,
        id: object['id'].toString(),
        name: object['name'],
        userId: userId,
        token: token,
        isGroup: object['isGroup'],
      ),
    );
  }

  return ListView(
    children: widgets,
  );
}

class ContainerWithProperties extends StatelessWidget {
  const ContainerWithProperties({
    @required this.object,
    @required this.formattedDate,
    @required this.id,
    @required this.name,
    @required this.userId,
    @required this.token,
    this.isGroup,
  });

  final object;
  final formattedDate;
  final String id;
  final String name;
  final String userId;
  final String token;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatScreen.id,
          arguments: ChatScreenArguments(token, userId, id, name, isGroup),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              object['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  object['lastSender'] != ''
                      ? object['lastSender'] + ': '
                      : 'Group chat empty.',
                ),
                Text(
                  object['lastMessage'],
                ),
                Spacer(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                color: Colors.black87,
                thickness: 0.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
