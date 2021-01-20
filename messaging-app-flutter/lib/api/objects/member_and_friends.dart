import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';

class MembersAndFriends {
  final List<UserForSingleDto> friends;
  final List<int> members;

  MembersAndFriends(this.friends, this.members);
}
