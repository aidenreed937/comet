/// User entity representing authenticated user data
class User {
  const User({
    required this.id,
    required this.email,
    required this.createdAt,
    this.name,
    this.avatar,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final DateTime createdAt;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatar == other.avatar &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      createdAt.hashCode;

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, avatar: $avatar, createdAt: $createdAt)';
}
