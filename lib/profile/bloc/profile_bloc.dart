import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(const ProfileState.uncompleted()) {
    on<ProfileStatusRequested>(_onProfileStatusRequested);
  }

  final DatabaseRepository _databaseRepository;

  void _onProfileStatusRequested(
      ProfileStatusRequested event, Emitter<ProfileState> emit) async {
    try {
      final user = await _databaseRepository.getUser(event.user.id);
      emit(
        user.isNotEmpty
            ? ProfileState.completed(user)
            : const ProfileState.uncompleted(),
      );
    } on GetUserProfileFailure catch (e) {
      emit(ProfileState.failure(
        e.message,
      ));
    }
  }
}
