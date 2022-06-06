import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class HomeView extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomeView({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}
