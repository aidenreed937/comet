import '../../domain/entities/user.dart';

/// DTO for User API response
class UserDto {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final String createdAt;

  const UserDto({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    required this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
