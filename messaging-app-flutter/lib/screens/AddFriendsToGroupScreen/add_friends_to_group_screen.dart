import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/screens/AddFriendsToGroupScreen/user_list_future_builder.dart';

class AddFriendsToGroupScreen extends StatefulWidget {
  static const String id = 'add_friends_to_group_screen';
  @override
  _AddFriendsToGroupScreenState createState() =>
      _AddFriendsToGroupScreenState();
}

class _AddFriendsToGroupScreenState extends State<AddFriendsToGroupScreen> {
  Widget ui;
  bool isFirstTime;

  @override
  void initState() {
    ui = Container();
    isFirstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AddFriendsToGroupScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    String token = args.token;
    String userId = args.userId;
    String groupId = args.groupId;
    String groupName = args.groupName;

    if (isFirstTime) {
      ui = UserListFutureBuilder(userId, groupId, token);
      isFirstTime = false;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kAppColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add friends to: $groupName',
          style: TextStyle(color: Colors.black),
        ),
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ui,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
