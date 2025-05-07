import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bani/pages/signup.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController mailcontroller = TextEditingController();
  String email = "";

  final _formkey = GlobalKey<FormState>();

  // Email Validatorss
  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please Enter Email';
    }

    // A more forgiving email validation regex
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final emailRegExp = RegExp(emailPattern);

    // If the email doesn't match, return error message
    if (!emailRegExp.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Reset Password Method (forgot password logic)
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password Reset Email has been sent!",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No user found for that email.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 70.0),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                  color: const Color.fromARGB(255, 233, 91, 91),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Enter your Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      // Email TextField
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: mailcontroller,
                          validator: emailValidator,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: const Color.fromARGB(179, 234, 107, 107),
                              size: 30.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),

                      // Send Email Button
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            // Set the email after validation
                            setState(() {
                              email = mailcontroller.text;
                            });
                            // Call the resetPassword method
                            resetPassword();
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 122, 122),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),

                      // Sign Up Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              "Create",
                              style: TextStyle(
                                color: Color.fromARGB(225, 184, 166, 6),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
