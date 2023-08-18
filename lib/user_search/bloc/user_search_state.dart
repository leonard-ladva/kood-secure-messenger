part of 'user_search_bloc.dart';

enum UserSearchStatus {
  inital,
  loading,
  success,
  failure,
}

final class UserSearchState extends Equatable {
  const UserSearchState._({
    required this.status,
    this.errorMessage,
    required this.results,
  });

  final UserSearchStatus status;
  final String? errorMessage;
  final List<User> results;

  UserSearchState.initial()
      : this._(
          status: UserSearchStatus.inital,
          results: [],
        );
  UserSearchState.loading()
      : this._(
          status: UserSearchStatus.loading,
          results: [],
        );
  const UserSearchState.success(List<User> results)
      : this._(
          status: UserSearchStatus.success,
          results: results,
        );

  UserSearchState.failure(String errorMessage)
      : this._(
          status: UserSearchStatus.failure,
          errorMessage: errorMessage,
          results: [],
        );

  @override
  List<Object> get props => [status, results];
}
