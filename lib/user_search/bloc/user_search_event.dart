part of 'user_search_bloc.dart';

sealed class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object> get props => [];
}

final class QueryChanged extends UserSearchEvent {
  const QueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
