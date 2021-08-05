import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/authentication/email_verification_screen.dart';
import 'package:krishi/screens/location_screen.dart';

class EmailAuthentication {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getAdminCredential(
      {email, password, isLog, context}) async {
    DocumentSnapshot _result = await users.doc(email).get();

    if (isLog) {
      emailLogin(email, password, context);
    } else {
      if (_result.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account already exist with this email'),
          ),
        );
      } else {
        //new user
        emailRegister(email, password, context);
      }
    }
    return _result;
  }

  emailLogin(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user!.uid!=null){
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      }
    }
  }

  emailRegister(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if (userCredential.user!.uid != null) {
        return users.doc(userCredential.user!.email).set({
          'uid': userCredential.user!.uid,
          'mobile': null,
          'email': userCredential.user!.email
        }).then((value) async {
          await userCredential.user!.sendEmailVerification().then((value) {
            Navigator.pushReplacementNamed(context, EmailVerificationScreen.id);
          });
        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add user'),
            ),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured'),
        ),
      );
    }
  }

}
