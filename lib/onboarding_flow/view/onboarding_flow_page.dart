import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/app/app.dart';

class OnboardingFlowPage extends StatelessWidget {
  const OnboardingFlowPage({
    required this.child,
    super.key,
  });

  static Page<void> page(Widget child) => MaterialPage<void>(
        child: OnboardingFlowPage(
          child: child,
        ),
      );

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            color: Colors.grey[200],
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
              context.flow<OnboardingFlowStatus>().complete(
                    (_) => OnboardingFlowStatus.completed,
                  );
            },
          )
        ],
      ),
      body: child,
    );
  }
}
