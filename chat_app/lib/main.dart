import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/fetch_data_from_firebase.dart';
import 'package:chat_app/views/home_view.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/user_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel? userModelForMain =
        await FetchDataFromFirebase.fetchDataForUserModel(currentUser.uid);
    if (userModelForMain != null) {
      runApp(
        AlreadyLogedIn(userModel: userModelForMain, firebaseUser: currentUser),
      );
    } else {
      runApp(const App());
    }
  } else {
    runApp(const App());
  }
}
//! user not loged In
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: LoginView(),
    );
  }
}
//! user already loged In
class AlreadyLogedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AlreadyLogedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: HomeView(
        userModel: userModel,
        firebaseUser: firebaseUser,
      ),
    );
  }
}
