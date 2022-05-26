import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/services/flutter_message.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: GestureDetector(
                  onTap: () {
                    if (kReleaseMode) return;
                    _email.text = 'mgivskud9@gmail.com';
                    _password.text = 'Password1';
                  },
                  child: FlutterLogo(
                    size: 80,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  final email = _email.text.trim().toLowerCase();
                  final password = _password.text.trim();
                  final response = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email, password: password)
                      .catchError((error) {
                    showError('$error');
                  });
                  if (response.user != null) {
                    Navigator.pushReplacementNamed(context, Routes.home);
                  }
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('Register', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  final email = _email.text.trim().toLowerCase();
                  final password = _password.text.trim();
                  final response = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: email, password: password)
                      .catchError((error) {
                    showError('$error');
                  });
                  if (response.user != null) {
                    Navigator.pushReplacementNamed(context, Routes.home);
                  }
                },
              ),
              TextButton(
                child: Text('Forgot your password?'),
                onPressed: () async {
                  final email = _email.text.trim().toLowerCase();
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email)
                      .catchError((error) {
                    showError('$error');
                  });
                  showSuccess('Check your email to reset your password');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
