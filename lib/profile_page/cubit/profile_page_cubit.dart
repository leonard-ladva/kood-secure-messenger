import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_page_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(
          ProfilePageState.loading(),
        );
  final DatabaseRepository _databaseRepository;

  void getUserData(String userId, User currentUser) async {
    if (userId == currentUser.id) {
      emit(
        ProfilePageState.success(currentUser),
      );
      return;
    }
    try {
      final user = await _databaseRepository.getUser(userId);
      user.isEmpty
          ? emit(ProfilePageState.failure("User not found"))
          : emit(ProfilePageState.success(user));
    } on GetUserProfileFailure catch (e) {
      emit(ProfilePageState.failure(e.message));
    } catch (e) {
      emit(ProfilePageState.failure(e.toString()));
    }
  }
}
