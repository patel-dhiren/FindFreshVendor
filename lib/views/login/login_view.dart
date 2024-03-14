import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/constants/constants.dart';

import 'components/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ))
        ],
      )),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 16,),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppConstant.signupView);
                },
                child: Text('SIGNUP'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
