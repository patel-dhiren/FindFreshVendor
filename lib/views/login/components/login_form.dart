import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../firebase/firebase_service.dart';
import '../../../gen/assets.gen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool _isLoading = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'\w+@\w+\.\w+';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        final user = await FirebaseService().signInWithEmailAndPassword(
          _email,
          _password,
        );
        if (user != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstant.homeView,
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        final snackBar =
            SnackBar(content: Text(e.message ?? 'An error occurred'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.center,
            child: Image.asset(Assets.images.logo.path),
          ),
          Text(
            'Vendor Login',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            'Grow your business with Find Fresh',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
              decoration: InputDecoration(labelText: 'Email address'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                _email = value ?? '';
              },
              validator: _validateEmail),
          SizedBox(
            height: 16,
          ),
          TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: _isHidden
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: _toggleVisibility,
                ),
              ),
              obscureText: _isHidden,
              onSaved: (value) {
                _password = value ?? '';
              },
              validator: _validatePassword),
          SizedBox(
            height: 24,
          ),
          Container(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.shade300),
              onPressed: () {
                _signIn();
              },
              child: Text('LOGIN'),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: _isLoading,
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          )
        ],
      ),
    );
  }
}
