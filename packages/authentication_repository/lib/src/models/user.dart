import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.onboardingFlowStatus,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  ///
  final OnboardingFlowStatus? onboardingFlowStatus;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  // /// Creates a new [User] instance from a json [Map].
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      onboardingFlowStatus: json['onboardingFlowStatus'] == null
          ? null
          : OnboardingFlowStatus.fromJson(
              json['onboardingFlowStatus'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo': photo,
      'onboardingFlowStatus': onboardingFlowStatus?.toJson(),
    };
  }

  User copyWith({
    String? email,
    String? id,
    String? name,
    String? photo,
    OnboardingFlowStatus? onboardingFlowStatus,
  }) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      onboardingFlowStatus: onboardingFlowStatus ?? this.onboardingFlowStatus,
    );
  }

  @override
  List<Object?> get props => [email, id, name, photo, onboardingFlowStatus];
}

enum OnboardingFlowStatus {
  profileSetup,
  appLockSetup,
  completed;

  String toJson() => name;
  static OnboardingFlowStatus fromJson(String json) => values.byName(json);
}
