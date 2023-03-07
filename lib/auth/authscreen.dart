import 'package:flutter/material.dart';
import 'package:it20192082_lab02/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentication")),
      body: const AuthForm(),
    );
  }
}