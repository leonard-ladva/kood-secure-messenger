import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage_repository/local_storage_repository.dart';
import 'package:storage_bucket_repository/storage_bucket_repository.dart';

part 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({
    required AuthenticationRepository authenticationRepository,
    required CryptographyRepository cryptographyRepository,
    required DatabaseRepository databaseRepository,
    required StorageBucketRepository storageBucketRepository,
    required LocalStorageRepository localStorageRepository,
  })  : _authenticationRepository = authenticationRepository,
        _cryptographyRepository = cryptographyRepository,
        _databaseRepository = databaseRepository,
        _storageBucketRepository = storageBucketRepository,
        _localStorageRepository = localStorageRepository,
        super(ProfileSetupState());

  final AuthenticationRepository _authenticationRepository;
  final CryptographyRepository _cryptographyRepository;
  final DatabaseRepository _databaseRepository;
  final StorageBucketRepository _storageBucketRepository;
  final LocalStorageRepository _localStorageRepository;

  void pickImageClicked() {
    try {
      pickImage();
    } on PlatformException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Something went wrong",
      ));
    }
  }

  void nameChanged(String value) async {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name]),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      emit(state.copyWith(
        photo: imageTemporary,
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitUserProfileData() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final currentUser = _authenticationRepository.currentUser;

    if (currentUser == User.empty) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    String? photoUrl;
    if (state.photo != null) {
      // upload photo to bucket and get photoUrl
      try {
        photoUrl = await _storageBucketRepository.saveProfilePic(state.photo!);
      } on SaveUserProfilePictureFailure catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: FormzSubmissionStatus.failure,
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }

    final myKeySet = await _cryptographyRepository.generateKeySet();
    _localStorageRepository.saveUserKeySet(currentUser.id, myKeySet);

    try {
      await _databaseRepository.saveUser(
        User(
          id: currentUser.id,
          name: state.name.value.trim(),
          photo: photoUrl,
          email: currentUser.email,
          publicKey: myKeySet.publicKey,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SaveUserProfileFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
