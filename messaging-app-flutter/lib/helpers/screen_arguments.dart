import 'package:signalr_client/hub_connection.dart';

class ConversationsScreenArguments {
  final String token;
  final String userId;
  final HubConnection hubConnection;

  ConversationsScreenArguments(this.token, this.userId, this.hubConnection);
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
  final HubConnection hubConnection;

  ChatScreenArguments(
    this.token,
    this.userId,
    this.groupId,
    this.groupName,
    this.isGroup,
    this.hubConnection,
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

class SetAdminScreenArguments {
  final String token;
  final String userId;
  final String groupId;
  final String groupName;

  SetAdminScreenArguments(
    this.token,
    this.userId,
    this.groupId,
    this.groupName,
  );
}

class CallScreenArguments {
  final String otherPersonId;
  final String otherPersonName;
  final HubConnection hubConnection;
  final bool shouldSendCallAnswer;

  CallScreenArguments(this.otherPersonId, this.otherPersonName,
      this.hubConnection, this.shouldSendCallAnswer);
}

class AnswerCallScreenArguments {
  final Object otherPerson;
  final HubConnection hubConnection;

  AnswerCallScreenArguments(this.otherPerson, this.hubConnection);
}
