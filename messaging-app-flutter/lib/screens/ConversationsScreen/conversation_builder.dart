import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';

import 'package:messaging_app_flutter/DTOs/message_group_to_return_dto.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/screens/ChatScreen/chat_screen.dart';

class ConversationBuilder extends StatelessWidget {
  const ConversationBuilder({
    @required this.object,
    @required this.formattedDate,
    @required this.id,
    @required this.name,
    @required this.userId,
    @required this.token,
    this.isGroup,
    @required this.hubConnection,
  });

  final MessageGroupToReturnDto object;
  final formattedDate;
  final String id;
  final String name;
  final String userId;
  final String token;
  final bool isGroup;
  final HubConnection hubConnection;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatScreen.id,
          arguments: ChatScreenArguments(
            token,
            userId,
            id,
            name,
            isGroup,
            hubConnection,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              object.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  object.lastSender != ''
                      ? object.lastSender + ': '
                      : 'Group chat empty.',
                ),
                Text(
                  object.lastMessage,
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
            SizedBox(
              width: double.infinity,
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
