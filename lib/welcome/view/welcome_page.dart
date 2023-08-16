import 'package:flutter/material.dart';
import 'package:relay/login/view/view.dart';
import 'package:relay/sign_up/sign_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: WelcomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Text.rich(
                  TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      fontFamily: '',
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: 'Relay',
                        style: TextStyle(
                          color: Color(0xFF2090ea),
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const Spacer(flex: 2),
                _SignInButton(),
                _SignUpButton(),
                const Spacer(flex: 4)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFFF9F6EE),
          ),
          foregroundColor: MaterialStateColor.resolveWith(
            (states) => Colors.black,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: () => Navigator.of(context).push<void>(LoginPage.route()),
        child: Text("Sign In"),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFF2090ea),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        child: Text('Sign Up'),
      ),
    );
  }
}
