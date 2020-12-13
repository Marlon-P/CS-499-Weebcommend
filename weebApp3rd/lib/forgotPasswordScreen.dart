import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "flushbarfunc.dart";

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Reset Password',
        textAlign: TextAlign.center,
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            child: TextFormField(
              validator: (val) => val.isEmpty ? 'Enter an email' : null,
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Enter Your Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onChanged: (val) {
                setState(() => email = val.trim());
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
                auth.sendPasswordResetEmail(email: email);
                Navigator.pop(context);
                showFlushBar(context: context, text: 'Password reset link was sent to your email.');
            },
            child: Text('Reset') ,
            elevation: 10,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),],
      ),
    );
  }
}
