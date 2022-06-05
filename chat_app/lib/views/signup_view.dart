// ignore_for_file: avoid_print
import 'package:chat_app/views/complete_profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void validation() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('Please fill all the fields and try again later');
    } else if (password.length <= 7 || confirmPassword.length <= 7) {
      print('Password should contain atleast 8 character');
    } else if (password != confirmPassword) {
      print('Password don\'t match please check your password');
    } else {
      proceedSignUp(email, password);
    }
  }

  Future<void> proceedSignUp(String? email, String? password) async {
    UserCredential credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      if (credential != null) {
        String uid = credential.user!.uid;
        UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullName: '',
          profilePic: '',
        );
        FirebaseFirestore firebaseFirestore = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap())
            .then((value) {
          print('SignUp Sucessfull');

          throw '';
        }).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return const CompleteProfile();
            }),
          );
        });
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Chat App',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    label: const Text('Enter email'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: const Text('Enter Password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: const Text('Re-Enter Password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CupertinoButton(
                  color: Colors.blue,
                  child: const Text('Sign Up'),
                  onPressed: () {
                    validation();
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Already have an Account !'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
