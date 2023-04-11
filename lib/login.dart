import 'dart:async';

import 'package:flutter/material.dart';
import 'main.dart';
import 'validation_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with validationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = ' ';
  String password = ' ';

  Widget build(context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Expanded(child: Container(margin: EdgeInsets.only(top: (30.0)))),
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(top: (20.0))),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration:
          InputDecoration(labelText: 'enter email ', hintText: 'you@gmail.com'),
      validator: validateEmail,
      onSaved: (value) {
        email = value!;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration:
          InputDecoration(labelText: 'enter password', hintText: 'password'),
      validator: validatePassword,
      onSaved: (value) {
        password = value!;
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      child: const Text('Submit'),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoList()),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
            }
          }
        }
      },
    );
  }
}
