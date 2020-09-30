class ConversationsScreenArguments {
  final String token;

  ConversationsScreenArguments(this.token);
}

class AddFriendScreenArguments {
  final String token;
  final String userId;

  AddFriendScreenArguments(this.token, this.userId);
}

class ChatScreenArguments {
  final String token;
  final String userId;
  final String groupId;
  final String groupName;
  final bool isGroup;

  ChatScreenArguments(
    this.token,
    this.userId,
    this.groupId,
    this.groupName,
    this.isGroup,
  );
}

class AddFriendsToGroupScreenArguments {
  final String token;
  final String userId;
  final String groupId;
  final String groupName;

  AddFriendsToGroupScreenArguments(
    this.token,
    this.userId,
    this.groupId,
    this.groupName,
  );
}
