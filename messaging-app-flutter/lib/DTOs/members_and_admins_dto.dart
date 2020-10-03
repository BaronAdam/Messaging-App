import 'package:messaging_app_flutter/DTOs/user_for_single_dto.dart';

class MembersAndAdminsDto {
  final List<UserForSingleDto> members;
  final List<int> adminIds;

  MembersAndAdminsDto(this.members, this.adminIds);
}
