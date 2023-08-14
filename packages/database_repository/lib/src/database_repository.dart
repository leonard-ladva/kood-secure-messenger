import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template get_user_profile_failure}
/// Thrown when attemptin to get the users profile.
/// {@endtemplate}
class GetUserProfileFailure implements Exception {
  /// {@macro get_user_profile_failure}
  const GetUserProfileFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template save_user_profile_failure}
/// Thrown when attempting to save the users profile.
/// {@endtemplate}
class SaveUserProfileFailure implements Exception {
  /// {@macro save_user_profile_failure}
  const SaveUserProfileFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template database_repository}
/// Repository which manages cloud data storage.
/// {@endtemplate}
class DatabaseRepository {
  /// {@macro database_repository}
  DatabaseRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // /// Whether or not the current environment is web
  // /// Should only be overridden for testing purposes. Otherwise,
  // /// defaults to [kIsWeb]
  // @visibleForTesting
  // bool isWeb = kIsWeb;

  /// Returns user data from firestore
  /// Returns empty user if user does not exist
  Future<User> getUser(String uid) async {
    try {
      var doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return User.empty;
      return User.fromJson(doc.data()!);
    } catch (_) {
      throw GetUserProfileFailure();
    }
  }

  /// Saves user data in firestore
  Future<User> saveUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return user;
    } catch (_) {
      throw SaveUserProfileFailure();
    }
  }
}
