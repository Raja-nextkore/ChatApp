import 'package:chat_app/views/chat_room_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void search() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                setState(() {
                  
                });
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
                  .where('email', isEqualTo: searchController.text.trim()).where('email',isNotEqualTo: widget.userModel.email)
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
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const ChatRoomView();
                          }),);
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilePic.toString()),
                        ),
                        title: Text(searchedUser.fullName.toString(),),
                        subtitle: Text(searchedUser.email.toString(),),
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
