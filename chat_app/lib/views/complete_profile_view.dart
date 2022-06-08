// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  CroppedFile? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropeImage(pickedFile);
    }
  }

  void cropeImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  void showAction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Upload Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text('Select from Gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take a Photo'),
                ),
              ],
            ),
          );
        });
  }

  void checkValues() {
    String fullName = fullNameController.text.trim();
    if (fullName.isEmpty || imageFile == null) {
      print('Please fill all the values');
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    log('calling uploadData');
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilepictures')
        .child(widget.userModel.uid.toString())
        .putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    String profilePic = await snapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();
    widget.userModel.fullName = fullName;
    widget.userModel.profilePic = profilePic;
    log('Data Uploading');
    log(fullName);
    log(profilePic);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .update(widget.userModel.toMap())
        .then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomeView(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        }),
      );
      log('Data Uploaded');
      log(fullName);
      log(profilePic);
    });
  }

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
                  radius: 60.0,
                  backgroundImage: (imageFile != null)
                      ? FileImage(File(imageFile!.path))
                      : null,
                  child: (imageFile == null)
                      ? const Icon(
                          Icons.person,
                          size: 80.0,
                          //color: Colors.blue,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  left: 80,
                  child: GestureDetector(
                    onTap: () {
                      showAction();
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: fullNameController,
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
                  checkValues();
                }),
          ],
        ),
      ),
    );
  }
}
