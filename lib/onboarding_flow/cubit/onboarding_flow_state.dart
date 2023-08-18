part of 'onboarding_flow_cubit.dart';

final class OnboardingFlowState extends Equatable {
  const OnboardingFlowState({
    this.status = OnboardingFlowStatus.profileSetup,
  });

  final OnboardingFlowStatus status;

  OnboardingFlowState copyWith({
    OnboardingFlowStatus? status,
  }) {
    return OnboardingFlowState(
      status: status ?? this.status,
    );
  }
  @override
  List<Object> get props => [status];
}
