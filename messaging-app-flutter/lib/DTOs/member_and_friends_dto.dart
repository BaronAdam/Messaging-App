import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';

class MembersAndFriendsDto {
  final List<UserForSingleDto> friends;
  final List<int> members;

  MembersAndFriendsDto(this.friends, this.members);
}
