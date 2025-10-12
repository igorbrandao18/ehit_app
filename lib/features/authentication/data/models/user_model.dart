// features/authentication/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Modelo de dados para User
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isActive;
  final String? phoneNumber;
  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? lastLoginAt;
  final List<String> preferences;
  final Map<String, dynamic> metadata;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.isActive,
    this.phoneNumber,
    this.lastLoginAt,
    required this.preferences,
    required this.metadata,
  });

  // JSON conversion helpers
  static DateTime _dateTimeFromJson(String dateString) => DateTime.parse(dateString);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
  
  static DateTime? _dateTimeFromJsonNullable(String? dateString) {
    if (dateString == null) return null;
    return DateTime.parse(dateString);
  }
  
  static String? _dateTimeToJsonNullable(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toIso8601String();
  }

  /// Cria UserModel a partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  /// Converte UserModel para JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Cria UserModel a partir de entidade User
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      displayName: user.displayName,
      profileImageUrl: user.profileImageUrl,
      bio: user.bio,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isEmailVerified: user.isEmailVerified,
      isActive: user.isActive,
      phoneNumber: user.phoneNumber,
      lastLoginAt: user.lastLoginAt,
      preferences: user.preferences,
      metadata: user.metadata,
    );
  }

  /// Converte UserModel para entidade User
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isEmailVerified: isEmailVerified,
      isActive: isActive,
      phoneNumber: phoneNumber,
      lastLoginAt: lastLoginAt,
      preferences: preferences,
      metadata: metadata,
    );
  }

  /// Cria UserModel a partir de Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      displayName: map['displayName'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      bio: map['bio'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isEmailVerified: map['isEmailVerified'] as bool,
      isActive: map['isActive'] as bool,
      phoneNumber: map['phoneNumber'] as String?,
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.parse(map['lastLoginAt'] as String) 
          : null,
      preferences: (map['preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Converte UserModel para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isActive': isActive,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences,
      'metadata': metadata,
    };
  }

  /// Cria uma cópia do UserModel com campos modificados
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isActive,
    String? phoneNumber,
    DateTime? lastLoginAt,
    List<String>? preferences,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, isActive: $isActive)';
  }
}
