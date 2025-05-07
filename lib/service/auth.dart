import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bani/pages/login.dart';
import 'package:shop_bani/pages/signup.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> Signout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error signing out. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteuser(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete(); // Delete the user from Firebase
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      }
    } catch (e) {
      print("Error deleting account: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting account. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
