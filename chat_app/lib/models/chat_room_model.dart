class ChatRoomModel {
  String? chatRoomId;
  List<String>? participent;

  ChatRoomModel({
    required this.chatRoomId,
    required this.participent,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chatRoomId'];
    participent = map['participent'];
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'participent': participent,
    };
  }
}
