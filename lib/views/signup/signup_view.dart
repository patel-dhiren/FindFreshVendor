import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/views/signup/components/signup_form.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

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
                child: SignupForm(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
