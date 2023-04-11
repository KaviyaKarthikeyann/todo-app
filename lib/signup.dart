import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'validation_mixin.dart';

class SignInSignUp extends StatefulWidget {
  final void Function() onSignUpSuccess; // New parameter
  SignInSignUp({required this.onSignUpSuccess});
  @override
  _SignInSignUpState createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> with validationMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSigningIn = false;

  Future<void> _signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed in: ${userCredential.user}');
      widget.onSignUpSuccess();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TodoList()),
      );
    } catch (e) {
      print('Failed to sign in: $e');
    }

    setState(() {
      _isSigningIn = false;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed up: ${userCredential.user}');
      widget.onSignUpSuccess();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TodoList()),
      );
    } catch (e) {
      print('Failed to sign up: $e');
    }

    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign in / Sign up'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(hintText: 'Email'),
            validator: validateEmail,
            /*onSaved: (value) {
        email = value!;
      },*/
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isSigningIn ? null : _signIn,
          child: Text('Sign in'),
        ),
        ElevatedButton(
          onPressed: _isSigningIn ? null : _signUp,
          child: Text('Sign up'),
        ),
      ],
    );
  }
}
