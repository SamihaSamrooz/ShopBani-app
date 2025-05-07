import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bani/admin/admin_login.dart';
import 'package:shop_bani/pages/bottomnav.dart';
import 'package:shop_bani/pages/forgotpassword.dart';
import 'package:shop_bani/pages/signup.dart';
import 'package:shop_bani/service/shared_pref.dart';
import 'package:shop_bani/widget/widget_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  Future<void> userLogin() async {
    try {
      // Sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: useremailcontroller.text.trim(),
        password: userpasswordcontroller.text,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (!userDoc.exists) {
          print("❌ No user document found for UID: ${user.uid}");
        } else {
          print("👤 User document found in Firestore: ${userDoc.data()}");

          // Save to SharedPreferences
          await SharedPreferenceHelper().saveUserId(user.uid);
          await SharedPreferenceHelper().saveUserEmail(userDoc['email']);
          await SharedPreferenceHelper().saveUserName(userDoc['name']);
          await SharedPreferenceHelper().saveUserProfile(userDoc['profile']);
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No User Found for the Email";
      } else if (e.code == 'wrong-password') {
        message = "The Password Provided is Wrong";
      } else {
        message = "Login Failed! Please check your credentials and try again.";
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 202, 103, 154),
                    Color.fromARGB(255, 135, 53, 54),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 60.0,
                bottom: 60.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "images/logo.jpg",
                      width: MediaQuery.of(context).size.width / 1.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 140, 140),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),
                            Text(
                              "Login",
                              style: AppWidget.headlineTextFeildStyle(),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: useremailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.email_rounded),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: userpasswordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Password";
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.password_outlined),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Forgotpassword(),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = useremailcontroller.text.trim();
                                    password = userpasswordcontroller.text;
                                  });
                                  userLogin();
                                }
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ), // increased padding
                                  width:
                                      MediaQuery.of(context).size.width /
                                      2, // adjusted width
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      167,
                                      4,
                                      47,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins1',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminLogin(),
                                  ),
                                );
                              },
                              child: Text(
                                "ADMIN LOGIN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins1',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Don't Have an Account? Signup now!",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
