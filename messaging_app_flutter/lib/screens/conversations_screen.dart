import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ConversationsScreen extends StatefulWidget {
  static const String id = 'conversations_screen';

  @override
  _ConversationsScreen createState() => _ConversationsScreen();
}

class _ConversationsScreen extends State<ConversationsScreen> {
  @override
  Widget build(BuildContext context) {
    final ConversationsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Your Chats',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print(args.token);
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(),
        ),
      ),
    );
  }
}
