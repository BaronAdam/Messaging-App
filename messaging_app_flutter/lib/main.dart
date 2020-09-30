import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/screens/add_friends_to_group_screen.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/conversations_screen.dart';
import 'screens/add_friend_screen.dart';
import 'screens/chat_screen.dart';

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
      },
    );
  }
}
