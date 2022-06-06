import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FetchDataFromFirebase {
  static Future<UserModel?> fetchDataForUserModel(String uid) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.data() != null) {
      userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
