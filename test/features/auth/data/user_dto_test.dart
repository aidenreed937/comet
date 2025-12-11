import 'package:comet/features/auth/data/models/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDto', () {
    final json = {
      'id': '123',
      'email': 'test@example.com',
      'name': 'Test User',
      'avatar': 'https://example.com/avatar.png',
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('should parse from JSON', () {
      final dto = UserDto.fromJson(json);

      expect(dto.id, '123');
      expect(dto.email, 'test@example.com');
      expect(dto.name, 'Test User');
      expect(dto.avatar, 'https://example.com/avatar.png');
      expect(dto.createdAt, '2024-01-01T00:00:00.000Z');
    });

    test('should convert to JSON', () {
      final dto = UserDto(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        avatar: 'https://example.com/avatar.png',
        createdAt: '2024-01-01T00:00:00.000Z',
      );

      final result = dto.toJson();

      expect(result['id'], '123');
      expect(result['email'], 'test@example.com');
      expect(result['name'], 'Test User');
      expect(result['avatar'], 'https://example.com/avatar.png');
      expect(result['created_at'], '2024-01-01T00:00:00.000Z');
    });

    test('should convert to entity', () {
      final dto = UserDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, '123');
      expect(entity.email, 'test@example.com');
      expect(entity.name, 'Test User');
      expect(entity.avatar, 'https://example.com/avatar.png');
      expect(entity.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
    });
  });
}
