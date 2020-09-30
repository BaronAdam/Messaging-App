import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/api/combined.dart';
import 'package:messaging_app_flutter/helpers/build_set_admin_ui.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';

class SetAdminScreen extends StatefulWidget {
  static const String id = 'set_admin_screen';
  @override
  _SetAdminScreenState createState() => _SetAdminScreenState();
}

class _SetAdminScreenState extends State<SetAdminScreen> {
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
    final SetAdminScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    String _token = args.token;
    String _userId = args.userId;
    String _groupId = args.groupId;
    String _groupName = args.groupName;

    if (isFirstTime) {
      ui = buildSetAdminUi(_userId, _groupId, _token);
      isFirstTime = false;
    }

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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              var response = await Combined.getMembersAndAdminInfo(
                _userId,
                _groupId,
                _token,
              );

              if (response == null) {
                return;
              }

              ui = buildMembersList(
                response,
                _userId,
                _groupId,
                _token,
                context,
              );

              setState(() {});
            },
          ),
        ],
        title: Text(
          'Set admins in: $_groupName',
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
