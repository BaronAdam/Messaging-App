import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/messages.dart';

Widget buildConversationsUI(userId, token) {
  return FutureBuilder(
    future: Messages.getChats(
      userId,
      token,
    ),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return new Text('Press button to start');
        case ConnectionState.waiting:
          return new Text('Awaiting result...');
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          else
            return buildListGroups(snapshot.data);
      }
    },
  );
}

ListView buildListGroups(data) {
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
      ContainerWithId(
        object: object,
        formattedDate: formattedDate,
        id: object['id'],
      ),
    );
  }

  return ListView(
    children: widgets,
  );
}

class ContainerWithId extends StatelessWidget {
  const ContainerWithId({
    @required this.object,
    @required this.formattedDate,
    @required this.id,
  });

  final object;
  final formattedDate;
  final int id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: return chat screen
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
