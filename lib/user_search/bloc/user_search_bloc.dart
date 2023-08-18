import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(UserSearchState.initial()) {
    on<QueryChanged>(_onQueryChanged);
  }
  final DatabaseRepository _databaseRepository;

  void _onQueryChanged(
    QueryChanged event,
    Emitter<UserSearchState> emit,
  ) async {
    try {
      final users = await _databaseRepository.searchUsers(event.query);
      emit(UserSearchState.success(users));
    } on SearchUsersException catch (e) {
      emit(UserSearchState.failure(e.message));
    } catch (_) {
      emit(UserSearchState.failure('An unknown error occured'));
    }
  }
}
