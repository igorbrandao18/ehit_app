// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: UserModel._dateTimeFromJson(json['createdAt'] as String),
      updatedAt: UserModel._dateTimeFromJson(json['updatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool,
      isActive: json['isActive'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      lastLoginAt:
          UserModel._dateTimeFromJsonNullable(json['lastLoginAt'] as String?),
      preferences: (json['preferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'createdAt': UserModel._dateTimeToJson(instance.createdAt),
      'updatedAt': UserModel._dateTimeToJson(instance.updatedAt),
      'isEmailVerified': instance.isEmailVerified,
      'isActive': instance.isActive,
      'phoneNumber': instance.phoneNumber,
      'lastLoginAt': UserModel._dateTimeToJsonNullable(instance.lastLoginAt),
      'preferences': instance.preferences,
      'metadata': instance.metadata,
    };
