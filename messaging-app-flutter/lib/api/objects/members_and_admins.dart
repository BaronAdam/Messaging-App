import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';

class MembersAndAdmins {
  final List<UserForSingleDto> members;
  final List<int> adminIds;

  MembersAndAdmins(this.members, this.adminIds);
}
