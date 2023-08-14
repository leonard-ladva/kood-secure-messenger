import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_flow_state.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(OnboardingFlowState()) {}

  final DatabaseRepository _databaseRepository;

  void getStatus(String userId) async {
    try {
      final user = await _databaseRepository.getUser(userId);
      if (user.isEmpty) {
        emit(OnboardingFlowState(
          status: OnboardingFlowStatus.profileSetup,
        ));
        return;
      }
      emit(state.copyWith(
        status: user.isApplockEnabled == true
            ? OnboardingFlowStatus.completed
            : OnboardingFlowStatus.appLockSetup,
      ));
    } on GetUserProfileFailure catch (e) {
      log("OnboardingFlowState error: $e");
    }
  }

  void setStatus(OnboardingFlowStatus status) {
    emit(state.copyWith(
      status: status,
    ));
  }
}
