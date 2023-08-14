import 'dart:developer';

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:relay/onboarding_flow/onboarding_flow.dart';

class AppLockSetupView extends StatelessWidget {
  const AppLockSetupView({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AppLockSetupView());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(
          Icons.lock_clock,
          size: 100,
        ),
        onPressed: () {
          log("clicked lock");
          context
              .flow<OnboardingFlowStatus>()
              .complete((_) => OnboardingFlowStatus.completed);
        },
      ),
    );
  }
}
