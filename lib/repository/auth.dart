import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<String?> createUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.sendEmailVerification();

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'error : The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'error : The account already exists for that email.';
      }
    } catch (e) {
      return 'error : $e';
    }
    return null;
  }

  Future<bool> checkEmailVerification() async {
    await _auth.currentUser?.reload();
    bool isVerified = _auth.currentUser!.emailVerified;
    print(isVerified);
    return isVerified;
  }

  Future<String> signInUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'error : No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'error : Wrong password provided for that user.';
      } else {
        return 'error : $e';
      }
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<bool> checkUser(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc.exists;
    } catch (e) {
      print('Error checking user: $e');
      return false;
    }
  }

  Future<UserModel?> getUser() async {
    User user = FirebaseAuth.instance.currentUser!;
    print(user.uid);
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .withConverter(
          fromFirestore: UserModel.fromMap,
          toFirestore: (userModel, options) => userModel.toMap(),
        );
    try {
      var userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        UserModel userModel = userSnapshot.data()!;
        print(userModel);
        return userModel;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
