class MessageGroupToReturnDto {
  final int id;
  final String name;
  final String lastSender;
  final String lastMessage;
  final String lastSent;
  final bool isGroup;

  MessageGroupToReturnDto(
    this.id,
    this.name,
    this.lastSender,
    this.lastMessage,
    this.lastSent,
    this.isGroup,
  );

  MessageGroupToReturnDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lastSender = json['lastSender'],
        lastMessage = json['lastMessage'],
        lastSent = json['lastSent'],
        isGroup = json['isGroup'];
}
