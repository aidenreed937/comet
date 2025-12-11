import 'package:comet/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Entity', () {
    test('should create user with all fields', () {
      final now = DateTime.now();
      final user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        avatar: 'https://example.com/avatar.png',
        createdAt: now,
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.avatar, 'https://example.com/avatar.png');
      expect(user.createdAt, now);
    });

    test('should support equality comparison', () {
      final now = DateTime.now();
      final user1 = User(id: '123', email: 'test@example.com', createdAt: now);
      final user2 = User(id: '123', email: 'test@example.com', createdAt: now);

      expect(user1, equals(user2));
    });

    test('should have proper toString', () {
      final now = DateTime.now();
      final user = User(id: '123', email: 'test@example.com', createdAt: now);

      expect(user.toString(), contains('123'));
      expect(user.toString(), contains('test@example.com'));
    });
  });
}
