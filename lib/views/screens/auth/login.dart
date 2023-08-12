import 'package:clips/controllers/auth_controller.dart';
import 'package:clips/views/screens/auth/signup.dart';
import 'package:clips/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../values.dart';
import '../../widgets/text_input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              appTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: buttonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                'Login into your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: TextInputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            CustomButton(
                onTap: () => AuthController().loginUser(
                      _emailController.text,
                      _passwordController.text,
                    ),
                text: 'Log In'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => SignUpScreen(),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, color: buttonColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
