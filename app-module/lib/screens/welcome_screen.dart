import 'package:flutter/material.dart';
import 'package:shop_app/screens/auth/auth_screen.dart';

import '../widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome to Shop App!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  CustomButton(
                    'GET STARTED',
                    Colors.white,
                    Theme.of(context).colorScheme.primary,
                    () {
                      Navigator.of(context)
                          .popAndPushNamed(AuthScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
