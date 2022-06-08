import 'dart:developer';

import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../models/chat_room_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ChatRoomView extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoomView(
      {Key? key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    String message = messageController.text.trim();
    messageController.clear();
    if (message.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        seen: false,
        createdOn: Timestamp.now(),
        text: message,
      );
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatRoomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chatRoom.lastMessage = message;
      // widget.chatRoom.createdOn = Timestamp.now();
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatRoomId)
          .set(widget.chatRoom.toMap());
    }
    log('message sent!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                NetworkImage(widget.targetUser.profilePic.toString()),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(widget.targetUser.fullName.toString()),
        ]),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(widget.chatRoom.chatRoomId)
                        .collection('messages')
                        .orderBy('createdOn', descending: true)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState == ConnectionState.active) {
                        if (snapshots.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshots.data as QuerySnapshot;
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.grey
                                            : Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight: const Radius.circular(20.0),
                                          bottomLeft: (currentMessage.sender ==
                                                  widget.userModel.uid)
                                              ? const Radius.circular(20.0)
                                              : const Radius.circular(0.0),
                                          bottomRight: (currentMessage.sender !=
                                                  widget.userModel.uid)
                                              ? const Radius.circular(20.0)
                                              : const Radius.circular(0.0),
                                        )),
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshots.hasError) {
                          return const Center(
                            child: Text(
                                'An error occure please check your internet connection'),
                          );
                        } else {
                          return const Center(
                            child: Text('Say hey !'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: TextField(
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        // send message function
                        sendMessage();
                      },
                      child: const Icon(
                        Icons.send,
                        size: 35.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
