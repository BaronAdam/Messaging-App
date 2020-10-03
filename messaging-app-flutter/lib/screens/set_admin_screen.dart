import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/DTOs/members_and_admins_dto.dart';
import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/repositories/group_repository.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

import '../constants.dart';

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
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Set admins in: $groupName',
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

class UserListFutureBuilder extends StatelessWidget {
  final userId;
  final groupId;
  final token;

  UserListFutureBuilder(this.userId, this.groupId, this.token);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GroupRepository.getMembersAndAdminInfo(userId, groupId, token),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kAppColor,
              ),
            );
          default:
            if (snapshot.data == null) {
              return ListView(
                children: [
                  Text('There was an error while processing your request.')
                ],
              );
            }
            return buildWidgetList(
                snapshot.data, userId, groupId, token, context);
        }
      },
    );
  }
}

class UserBuilder extends StatefulWidget {
  final UserForSingleDto member;
  final List<int> adminIds;
  final String userId;
  final String groupId;
  final String token;

  UserBuilder(
      this.member, this.adminIds, this.userId, this.groupId, this.token);

  @override
  _UserBuilderState createState() =>
      _UserBuilderState(member, userId, groupId, token, adminIds);
}

class _UserBuilderState extends State<UserBuilder> {
  final UserForSingleDto member;
  final List<int> adminIds;
  final String userId;
  final String groupId;
  final String token;

  _UserBuilderState(
      this.member, this.userId, this.groupId, this.token, this.adminIds);

  static const removeIcon = Icon(
    Icons.remove,
    color: Colors.red,
  );

  static const addIcon = Icon(
    Icons.add,
    color: Colors.green,
  );

  bool isAdmin;
  @override
  initState() {
    isAdmin = adminIds.contains(member.id);

    super.initState();
  }

  bool isFirstTime = true;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      icon = adminIds.contains(member.id) ? removeIcon : addIcon;
      isFirstTime = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              member.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            IconButton(
              icon: icon,
              onPressed: () async {
                var result = await Group.changeAdminStatus(
                  userId,
                  groupId,
                  member.id,
                  token,
                );

                if (result) {
                  isAdmin = !isAdmin;
                  icon = isAdmin ? removeIcon : addIcon;
                  setState(() {});
                } else {
                  showNewDialog(
                    'Error',
                    'There was an error while processing your request.',
                    DialogType.WARNING,
                    context,
                  );
                }
              },
            )
          ],
        ),
        Text(member.username),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(
            color: Colors.black87,
            thickness: 0.5,
          ),
        )
      ],
    );
  }
}

ListView buildWidgetList(
  MembersAndAdminsDto data,
  userId,
  groupId,
  token,
  context,
) {
  List<Widget> list = [];

  for (var member in data.members) {
    if (member.id == int.parse(userId)) continue;

    list.add(UserBuilder(member, data.adminIds, userId, groupId, token));
  }
  return ListView(
    children: list,
  );
}
