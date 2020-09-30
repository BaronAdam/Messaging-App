import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/user.dart';
import 'package:messaging_app_flutter/components/rounded_button.dart';
import 'package:messaging_app_flutter/helpers/build_add_friends_ui.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';

import '../constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final AddFriendScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    String _token = args.token;
    String _userId = args.userId;

    String _input;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
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
                onPressed: () async {
                  var result = await User.findUser(
                    _token,
                    _input,
                  );

                  container =
                      buildAddFriendsUi(result, _userId, _token, context);
                  setState(() {});
                },
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
}
