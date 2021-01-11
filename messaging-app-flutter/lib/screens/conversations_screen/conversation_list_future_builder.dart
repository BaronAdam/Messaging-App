import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';

import 'package:messaging_app_flutter/DTOs/message_group_to_return_dto.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/conversations_screen/conversation_builder.dart';

class ConversationsListFutureBuilder extends StatelessWidget {
  final userId;
  final token;
  final HubConnection hubConnection;

  ConversationsListFutureBuilder(this.userId, this.token, this.hubConnection);

  @override
  Widget build(BuildContext context) {
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
            return buildWidgetList(
              snapshot.data,
              userId,
              token,
              hubConnection,
            );
        }
      },
    );
  }

  ListView buildWidgetList(
    List<MessageGroupToReturnDto> data,
    userId,
    token,
    hubConnection,
  ) {
    List<Widget> widgets = [];

    for (var item in data) {
      var date = DateTime.parse(item.lastSent);

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
        ConversationBuilder(
          object: item,
          formattedDate: formattedDate,
          id: item.id.toString(),
          name: item.name,
          userId: userId,
          token: token,
          isGroup: item.isGroup,
          hubConnection: hubConnection,
        ),
      );
    }

    return ListView(
      children: widgets,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
