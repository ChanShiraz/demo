// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String dob;
  final String gender;
  String imgLink;
  String? email;
  String? phone;
  UserModel(
      {required this.name,
      required this.dob,
      required this.gender,
      required this.imgLink,
      this.email,
      this.phone});

  UserModel copyWith({
    String? name,
    String? dob,
    String? gender,
    String? imgLink,
  }) {
    return UserModel(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      imgLink: imgLink ?? this.imgLink,
      email: email ?? email,
      phone: phone ?? phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'dob': dob,
      'gender': gender,
      'imgLink': imgLink,
      'email': email,
      'phone': phone
    };
  }

  factory UserModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final map = snapshot.data();
    return UserModel(
      name: map?['name'] as String,
      dob: map?['dob'] as String,
      gender: map?['gender'] as String,
      imgLink: map?['imgLink'] as String,
      email: map?['email'] as String?,
      phone: map?['phone'] as String?,
    );
  }
  @override
  String toString() {
    return 'UserModel(name: $name, dob: $dob, gender: $gender, imgLink: $imgLink)';
  }
}
