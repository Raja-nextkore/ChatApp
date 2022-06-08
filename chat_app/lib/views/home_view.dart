// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/helper/fetch_data_from_firebase.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/views/chat_room_view.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:chat_app/views/search_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class HomeView extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeView(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: true,
        actions: [
          CupertinoButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: ((context) {
                  return const LoginView();
                })),
              );
            },
            child: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .where('participent.${widget.userModel.uid}', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatRoomsSnapshot =
                        snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      // reverse: true,
                      itemCount: chatRoomsSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomsSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        Map<String, dynamic> participent =
                            chatRoomModel.participent!;
                        List<String> participentKeys =
                            participent.keys.toList();
                        participentKeys.remove(widget.userModel.uid);

                        return FutureBuilder(
                          future: FetchDataFromFirebase.fetchDataForUserModel(
                              participentKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatRoomView(
                                            targetUser: targetUser,
                                            chatRoom: chatRoomModel,
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser);
                                      }),
                                    );
                                  },
                                  title: Text(targetUser.fullName.toString()),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          '')
                                      ? Text(
                                          chatRoomModel.lastMessage.toString())
                                      : const Text(
                                          'Say hey',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: NetworkImage(
                                        targetUser.profilePic.toString()),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text('Please connect with friends'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchView(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
