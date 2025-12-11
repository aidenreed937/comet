/// User entity representing authenticated user data
class User {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    required this.createdAt,
  });

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
