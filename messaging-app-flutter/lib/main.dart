import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/injection.dart';
import 'screens/answer_call_screen/answer_call_screen.dart';
import 'screens/call_screen/call_screen.dart';
import 'screens/add_friends_to_group_screen/add_friends_to_group_screen.dart';
import 'screens/set_admin_screen/set_admin_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/register_screen/register_screen.dart';
import 'screens/conversations_screen/conversations_screen.dart';
import 'screens/add_friend_screen/add_friend_screen.dart';
import 'screens/chat_screen/chat_screen.dart';

void main() {
  configureDependencies();
  runApp(MessagingApp());
}

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ConversationsScreen.id: (context) => ConversationsScreen(),
        AddFriendScreen.id: (context) => AddFriendScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        AddFriendsToGroupScreen.id: (context) => AddFriendsToGroupScreen(),
        SetAdminScreen.id: (context) => SetAdminScreen(),
        CallScreen.id: (context) => CallScreen(),
        AnswerCallScreen.id: (context) => AnswerCallScreen(),
      },
    );
  }
}
