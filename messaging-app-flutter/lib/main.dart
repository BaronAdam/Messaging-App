import 'package:flutter/material.dart';
import 'screens/AnswerCallScreen/answer_call_screen.dart';
import 'screens/CallScreen/call_screen.dart';

import 'screens/AddFriendsToGroupScreen/add_friends_to_group_screen.dart';
import 'screens/SetAdminScreen/set_admin_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/LoginScreen/login_screen.dart';
import 'screens/RegisterScreen/register_screen.dart';
import 'screens/ConversationsScreen/conversations_screen.dart';
import 'screens/AddFriendScreen/add_friend_screen.dart';
import 'screens/ChatScreen/chat_screen.dart';

void main() {
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
