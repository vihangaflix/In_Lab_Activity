import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  bool isLogin = false;
  final logger = Logger();

  formauth() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  void submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential? userCredential;

    try {
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "username": username,
          "email": email,
        });
      }
    } catch (e) {
      logger.e('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            height: 200,
            child: Image.asset("assets/Recepie.jpg"),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLogin)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey("username"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _username = newValue!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide()),
                            labelText: "Enter your username",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey("email"),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "Incorrect email";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _email = newValue!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter your email",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      key: const ValueKey("password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a email";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _password = newValue!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter your password",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.purple, // background
                        ),
                        onPressed: () {
                          formauth();
                        },
                        child: isLogin
                            ? Text(
                                "Login",
                                style: GoogleFonts.roboto(fontSize: 16),
                              )
                            : Text("Sign Up",
                                style: GoogleFonts.roboto(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ?  Text("Don't have a account", style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),)
                          :  Text("Already have a account", style: GoogleFonts.roboto(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
