// features/authentication/domain/entities/user.dart

import 'package:equatable/equatable.dart';

/// Entidade que representa um usuário
class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isActive;
  final String? phoneNumber;
  final DateTime? lastLoginAt;
  final List<String> preferences;
  final Map<String, dynamic> metadata;

  const User({
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

  /// Cria uma cópia do usuário com campos modificados
  User copyWith({
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
    return User(
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

  /// Verifica se o usuário tem perfil completo
  bool get hasCompleteProfile {
    return displayName != null && 
           displayName!.isNotEmpty && 
           profileImageUrl != null && 
           profileImageUrl!.isNotEmpty;
  }

  /// Obtém o nome de exibição (displayName ou username)
  String get displayNameOrUsername {
    return displayName?.isNotEmpty == true ? displayName! : username;
  }

  /// Verifica se o usuário está online (login recente)
  bool get isOnline {
    if (lastLoginAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    return difference.inMinutes < 30; // Considerado online se login foi há menos de 30 min
  }

  /// Obtém a idade da conta em dias
  int get accountAgeInDays {
    final now = DateTime.now();
    return now.difference(createdAt).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        displayName,
        profileImageUrl,
        bio,
        createdAt,
        updatedAt,
        isEmailVerified,
        isActive,
        phoneNumber,
        lastLoginAt,
        preferences,
        metadata,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, isActive: $isActive)';
  }
}
