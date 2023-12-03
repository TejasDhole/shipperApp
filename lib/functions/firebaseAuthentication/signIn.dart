import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/colors.dart';
import '../alert_dialog.dart';

FirebaseAuth auth = FirebaseAuth.instance;

signIn(String email, String password, BuildContext context) async {
  late UserCredential credential;
  try {
    credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showSnackBar('No user found with this email', deleteButtonColor,
          const Icon(Icons.warning), context);
      return null;
    } else if (e.code == 'wrong-password') {
      showSnackBar('Wrong Password', deleteButtonColor,
          const Icon(Icons.warning), context);
      return null;
    } else {
      showSnackBar(
          e.code, deleteButtonColor, const Icon(Icons.warning), context);
    }
  }
}

signUp(String email, String password, BuildContext context) async {
  try {
    return await auth.createUserWithEmailAndPassword(
        email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      alertDialog('Weak password', 'Entered password is too weak', context);
    } else if (e.code == 'email-already-in-use') {
      showSnackBar('An account exits with the given email address.',
          deleteButtonColor, const Icon(Icons.warning), context);
    } else if (e.code == 'invalid-email') {
      showSnackBar('Email Address is not valid.', deleteButtonColor,
          const Icon(Icons.warning), context);
    } else {
      alertDialog('Error', '$e', context);
    }
  }
}
