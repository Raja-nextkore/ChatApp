import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomId;
  Map<String,dynamic>? participent;
  String? lastMessage;
  //Timestamp? createdOn;

  ChatRoomModel({
    required this.chatRoomId,
    required this.participent,
    required this.lastMessage,
    //required this.createdOn,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chatRoomId'];
    participent = map['participent'];
    lastMessage = map['lastMessage'];
    //createdOn = map['createdOn'];
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'participent': participent,
      'lastMessage': lastMessage,
     // 'createdOn' : createdOn,
    };
  }
}
