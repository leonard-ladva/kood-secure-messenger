import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
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

      if (user.onboardingFlowStatus == null) {
        emit(OnboardingFlowState(
          status: OnboardingFlowStatus.appLockSetup,
        ));
        return;
      }

      emit(state.copyWith(
        status: user.onboardingFlowStatus,
      ));
    } on GetUserProfileFailure catch (e) {
      log("OnboardingFlowState error: $e");
    }
  }

  void setStatus(User user, OnboardingFlowStatus status) async {
    try {
      await _databaseRepository.updateUserOnboardingStatus(user, status);
      emit(state.copyWith(
        status: status,
      ));
    } on UpdateUserOnboardingStatusFailure catch (e) {
      log("UpdateUserProfileFailure error: $e");
    } catch (_) {
      log("UpdateUserProfileFailure error: ");
    }
  }
}
