import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/DTOs/message_group_to_return_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/messages.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/add_friend_screen.dart';
import 'package:messaging_app_flutter/screens/chat_screen.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class ConversationsScreen extends StatefulWidget {
  static const String id = 'conversations_screen';

  @override
  _ConversationsScreen createState() => _ConversationsScreen();
}

class _ConversationsScreen extends State<ConversationsScreen> {
  Widget ui;
  bool isFirstTime;
  HubConnection hubConnection;

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

    String userId = args.userId;
    String token = args.token;
    hubConnection = args.hubConnection;

    if (isFirstTime) {
      ui = ConversationsListFutureBuilder(userId, token, hubConnection);
      isFirstTime = false;
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
                arguments: AddFriendScreenArguments(token, userId),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var result = await Messages.getChats(
                userId,
                token,
              );

              if (!checkResponse(result, context)) return;

              ui = buildWidgetList(result, userId, token, hubConnection);

              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await createGroup(userId, token, context);
              var result = await Messages.getChats(
                userId,
                token,
              );

              if (!checkResponse(result, context)) return;

              ui = buildWidgetList(result, userId, token, hubConnection);

              setState(() {});
            },
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
}

Future createGroup(userId, token, context) async {
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
    var result = await Group.addGroup(userId, token, text[0]);

    if (result == null) {
      showNewDialog(
        'Group created',
        'Successfully created group: ${text[0]}',
        DialogType.SUCCES,
        context,
      );
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

bool checkResponse(response, context) {
  if (response == null) {
    showNewDialog(
      'Error',
      'There was an error while processing your request.',
      DialogType.WARNING,
      context,
    );
    return false;
  }

  return true;
}

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
}

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
