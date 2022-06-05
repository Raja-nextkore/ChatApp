// ignore_for_file: avoid_print

import 'package:chat_app/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Complete Profile'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.3),
                  radius: 60.0,
                  child: const Icon(
                    Icons.person,
                    size: 80.0,
                    color: Colors.blue,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 80.0,
                  child: GestureDetector(
                    onTap: () {
                      print('profile added');
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.deepPurple,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: InputDecoration(
                label: const Text('Enter Full Name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CupertinoButton(
                color: Colors.blue,
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const HomeView();
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
