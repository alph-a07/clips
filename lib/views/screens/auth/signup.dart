import 'package:clips/controllers/auth_controller.dart';
import 'package:clips/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../values.dart';
import '../../widgets/text_input_field.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final AuthController _authController =
      AuthController(); // Use same instance of AuthController to use profile picture in cache

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
              style: TextStyle(
                fontSize: 32,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                'Create a new account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage('images/img.png'),
                  backgroundColor: Colors.black,
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () => _authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                onTap: () => _authController.registerUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _authController.profilePhoto),
                text: 'Sign Up'),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: const Text(
                    'Login',
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
