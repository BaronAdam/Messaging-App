import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app_flutter/api/user.dart';
import 'package:messaging_app_flutter/components/rounded_button.dart';
import 'package:messaging_app_flutter/DTOs//user_for_single_dto.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/add_friend_screen/add_friend_widget_builder.dart';

class AddFriendScreen extends StatefulWidget {
  static const String id = 'add_friends_screen';

  @override
  _AddFriendScreen createState() => _AddFriendScreen();
}

class _AddFriendScreen extends State<AddFriendScreen> {
  Widget container;

  @override
  void initState() {
    container = Container();
    super.initState();
  }

  String _token, _userId, _input;

  @override
  Widget build(BuildContext context) {
    final AddFriendScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    _token = args.token;
    _userId = args.userId;

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
          'Add Friend',
          style: TextStyle(color: Colors.black),
        ),
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _input = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter email or username',
                ),
              ),
              RoundedButton(
                title: 'Search',
                color: kAppColor,
                onPressed: findFriend,
              ),
              Container(
                child: container,
              )
            ],
          ),
        ),
      ),
    );
  }

  void findFriend() async {
    var resultUser = await User.findUser(_token, _input);

    var resultFriends = await User.getFriends(_userId, _token);

    if (checkUserRequestResult(resultUser, context) &&
        checkFriendsRequestResult(resultFriends, context)) {
      var user;
      List friends;

      try {
        user = UserForSingleDto.fromJson(
          jsonDecode(resultUser),
        );
        friends = jsonDecode(resultFriends);
      } catch (e) {
        print(e);
        return;
      }

      bool isInFriends = false;

      if (friends.contains(user.id)) {
        isInFriends = true;
      }

      container = AddFriendWidgetBuilder(
        user,
        _userId,
        _token,
        isInFriends,
      );

      setState(() {});
    }
  }

  bool checkUserRequestResult(result, context) {
    if (result == null) {
      showNewDialog(
        'Error',
        'There was an error while processing your request',
        DialogType.WARNING,
        context,
      );
      return false;
    }

    return true;
  }

  bool checkFriendsRequestResult(result, context) {
    if (result == null) {
      showNewDialog(
        'Error',
        'There was an error while processing your request',
        DialogType.WARNING,
        context,
      );
      return false;
    }

    return true;
  }
}
