import 'package:flutter/material.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ProfileSetupPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.person,
          size: 100,
        ),
      ),
    );
  }
}
