import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DetailsRepository {
  User user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadDetails(UserModel userModel, File imageFile) async {
    //uploading the profile image
    String imageLink = '';
    final imgRef = storageRef.child(user.uid);
    try {
      await imgRef.putFile(imageFile);
      imageLink = await imgRef.getDownloadURL();
      userModel.imgLink = imageLink;
    } catch (e) {
      print(e);
    }
    final detailsRef = firestore
        .collection('users')
        .withConverter(
          fromFirestore: UserModel.fromMap,
          toFirestore: (userModel, options) => userModel.toMap(),
        )
        .doc(user.uid);
    try {
      await detailsRef.set(userModel);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
