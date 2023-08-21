// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      onboardingFlowStatus: $enumDecodeNullable(
          _$OnboardingFlowStatusEnumMap, json['onboardingFlowStatus']),
      publicKey: json['publicKey'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'onboardingFlowStatus': instance.onboardingFlowStatus,
      'publicKey': instance.publicKey,
    };

const _$OnboardingFlowStatusEnumMap = {
  OnboardingFlowStatus.profileSetup: 'profileSetup',
  OnboardingFlowStatus.appLockSetup: 'appLockSetup',
  OnboardingFlowStatus.completed: 'completed',
};
