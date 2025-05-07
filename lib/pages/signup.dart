import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bani/pages/bottomnav.dart';
import 'package:shop_bani/pages/login.dart';
import 'package:shop_bani/service/database.dart';
import 'package:shop_bani/service/shared_pref.dart';
import 'package:shop_bani/widget/widget_support.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";

  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        email = mailcontroller.text.trim();
        password = passwordcontroller.text.trim();
        name = namecontroller.text.trim();
      });

      try {
        // Register user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );

          // Add user info to Firestore
          Map<String, dynamic> addUserInfo = {
            "name": name,
            "email": email,
            "profile": "",
          };

          await DatabaseMethods().addUserDetail(addUserInfo, user.uid);

          // Save user data to SharedPreferences
          await SharedPreferenceHelper().saveUserName(namecontroller.text);
          await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
          await SharedPreferenceHelper().saveUserId(user.uid);

          await Future.delayed(Duration(seconds: 2)); // Adding a delay

          if (!mounted) return;

          // Navigate to the BottomNav screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
              child: Text(" "),
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
                      padding: EdgeInsets.only(left: 10.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.20,
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
                              "Sign Up",
                              style: AppWidget.headlineTextFeildStyle(),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: namecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'UserName',
                                hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.person_2),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: mailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
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
                              controller: passwordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.password_rounded),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            GestureDetector(
                              onTap: registration,
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  width: 200,
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
                                    "SIGN UP",
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
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      "Already have an Account? Log in!",
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
