part of 'profile_setup_cubit.dart';

final class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.photo,
    this.name = const Name.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Name name;
  final File? photo;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [name, photo, status, isValid, errorMessage];

  ProfileSetupState copyWith({
    Name? name,
    File? photo,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return ProfileSetupState(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
