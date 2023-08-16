import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:relay/helpers/helpers.dart';
import 'package:relay/profile_page/profile_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state) {
        if (state.status == ProfilePageStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == ProfilePageStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Error'),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PhotoWidget(state.user),
              const SizedBox(height: 16),
              _NameWidget(state.user),
              const SizedBox(height: 16),
              _EmailWidget(state.user),
              const SizedBox(height: 16),
              _ChatButton(state.user),
              const SizedBox(height: 16),
              QrImageView(
                data:
                    'relaymessenger://www.relay-messenger.com/user/${state.user.id}',
                size: 200,
                backgroundColor: Colors.white,
              )
            ],
          ),
        );
      },
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
          fontSize: 50,
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
