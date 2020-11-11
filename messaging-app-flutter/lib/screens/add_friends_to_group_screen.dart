import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/DTOs/member_and_friends_dto.dart';
import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';
import 'package:messaging_app_flutter/api/group.dart';
import 'package:messaging_app_flutter/api/repositories/group_repository.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';

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
            color: Colors.black,
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

class UserListFutureBuilder extends StatelessWidget {
  final userId;
  final groupId;
  final token;

  UserListFutureBuilder(this.userId, this.groupId, this.token);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GroupRepository.getFriendsAndMembers(
        userId,
        groupId,
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
            if (snapshot.data == null) {
              return ListView(
                children: [
                  Text('There was an error while processing your request.'),
                ],
              );
            }
            return buildFriendsList(
                snapshot.data, userId, groupId, token, context);
        }
      },
    );
  }
}

ListView buildFriendsList(
    MembersAndFriendsDto data, userId, groupId, token, context) {
  List<Widget> list = [];

  for (var friend in data.friends) {
    list.add(
      UserBuilder(friend, userId, groupId, token, data.members),
    );
  }

  return ListView(
    children: list,
  );
}

class UserBuilder extends StatefulWidget {
  final UserForSingleDto friend;
  final String userId;
  final String groupId;
  final String token;
  final List<int> members;

  UserBuilder(
    this.friend,
    this.userId,
    this.groupId,
    this.token,
    this.members,
  );

  @override
  _UserBuilderState createState() =>
      _UserBuilderState(friend, userId, groupId, token, members);
}

class _UserBuilderState extends State<UserBuilder> {
  final UserForSingleDto friend;
  final String userId;
  final String groupId;
  final String token;
  final List<int> members;

  _UserBuilderState(
    this.friend,
    this.userId,
    this.groupId,
    this.token,
    this.members,
  );

  bool isntInFriends = false;

  @override
  initState() {
    isntInFriends = !members.contains(friend.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              friend.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Spacer(),
            isntInFriends
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      var response = await Group.addMemberToGroup(
                        userId,
                        groupId,
                        [friend.id],
                        token,
                      );
                      if (response) {
                        setState(() {
                          isntInFriends = false;
                        });
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
                : IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: null,
                  ),
          ],
        ),
        Text(friend.username),
      ],
    );
  }
}
