import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:relay/helpers/helpers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(this.user, {super.key});
  final User user;

  static Page<void> page(User user) =>
      MaterialPage<void>(child: ProfilePage(user));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PhotoWidget(user),
            const SizedBox(height: 16),
            _NameWidget(user),
            const SizedBox(height: 16),
            _EmailWidget(user),
            const SizedBox(height: 16),
            _ChatButton(user),
          ],
        ),
      ),
    );
  }
}

class _PhotoWidget extends StatelessWidget {
  const _PhotoWidget(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundImage: user.photo == null ? null : NetworkImage(user.photo!),
      radius: 75,
      backgroundColor: Color(0xFFb8e986),
      child: Text(
        initials(
          user.name ?? '',
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF528617),
        ),
      ),
    );
  }
}

class _NameWidget extends StatelessWidget {
  const _NameWidget(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Text(
      user.name ?? '',
      style: TextStyle(fontSize: 40),
    );
  }
}

class _EmailWidget extends StatelessWidget {
  const _EmailWidget(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Text(
      user.email ?? '',
      style: TextStyle(fontSize: 20),
    );
  }
}

class _ChatButton extends StatelessWidget {
  const _ChatButton(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Chat'),
    );
  }
}
