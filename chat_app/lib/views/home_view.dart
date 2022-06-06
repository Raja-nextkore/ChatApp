import 'package:chat_app/views/search_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: const [],
          ),
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
