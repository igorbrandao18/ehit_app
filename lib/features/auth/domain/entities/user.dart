// features/auth/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isPremium;
  final List<String> favoriteGenres;
  final Map<String, dynamic> preferences;
  
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    required this.createdAt,
    this.isPremium = false,
    this.favoriteGenres = const [],
    this.preferences = const {},
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName)';
  }
}
