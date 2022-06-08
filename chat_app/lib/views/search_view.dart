import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/views/chat_room_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_room_model.dart';
import '../models/user_model.dart';

class SearchView extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchView(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participent.${widget.userModel.uid}', isEqualTo: true)
        .where('participent.${targetUser.uid}', isEqualTo: true)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      //! fetch the existing one
      var docData = querySnapshot.docs[0].data();
      ChatRoomModel exisitingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = exisitingChatRoom;
    } else {
      //! creating a new one
      ChatRoomModel newChatRoom = ChatRoomModel(
        chatRoomId: uuid.v1(),
        participent: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
        lastMessage: '',
        //createdOn: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
      log('new chat room created');
    }
    return chatRoom;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                  label: const Text('Enter user email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CupertinoButton(
              onPressed: () {
                setState(() {});
              },
              color: Colors.blue,
              child: const Text('Search'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: searchController.text.trim())
                  .where('email', isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot quearySnapshot =
                        snapshot.data as QuerySnapshot;
                    if (quearySnapshot.docs.isNotEmpty) {
                      Map<String, dynamic> userMap =
                          quearySnapshot.docs[0].data() as Map<String, dynamic>;
                      UserModel searchedUser = UserModel.fromMap(userMap);
                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? chatRoom =
                              await getChatRoomModel(searchedUser);
                          if (chatRoom != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ChatRoomView(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                  targetUser: searchedUser,
                                  chatRoom: chatRoom,
                                );
                              }),
                            );
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilePic.toString()),
                        ),
                        title: Text(
                          searchedUser.fullName.toString(),
                        ),
                        subtitle: Text(
                          searchedUser.email.toString(),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return const Center(child: Text('No Result Found!'));
                    }
                  } else if (snapshot.hasError) {
                    return const Text('An error occured!');
                  } else {
                    return const Text('No Result Found!');
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
          ],
        ),
      )),
    );
  }
}
