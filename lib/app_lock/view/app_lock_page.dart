import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';

class AppLockPage extends StatelessWidget {
  const AppLockPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AppLockPage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AppBloc>().add(const AppLogoutRequested()),
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'Currently signed in as:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              user.email ?? 'unknown email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.fingerprint,
              size: 100,
            ),
            const Text(
              'App Locked',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              'Unlock with biometrics',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<AppBloc>().add(AppUnlockRequested()),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              child: Text(
                'Unlock',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
