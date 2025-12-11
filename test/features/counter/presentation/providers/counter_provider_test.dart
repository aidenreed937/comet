import 'package:comet/features/counter/domain/entities/counter.dart';
import 'package:comet/features/counter/domain/repositories/counter_repository.dart';
import 'package:comet/features/counter/presentation/providers/counter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Counter(value: 0));
  });

  group('CounterController', () {
    late ProviderContainer container;
    late MockCounterRepository mockRepository;

    setUp(() {
      mockRepository = MockCounterRepository();
      when(() => mockRepository.saveCounter(any())).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          counterRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be Counter with value 0', () {
      final counter = container.read(counterControllerProvider);
      expect(counter, equals(const Counter(value: 0)));
    });

    test('increment should increase value by 1', () {
      container.read(counterControllerProvider.notifier).increment();
      final counter = container.read(counterControllerProvider);
      expect(counter.value, equals(1));
    });

    test('decrement should decrease value by 1', () {
      container.read(counterControllerProvider.notifier)
        ..increment()
        ..increment()
        ..decrement();
      final counter = container.read(counterControllerProvider);
      expect(counter.value, equals(1));
    });

    test('reset should set value to 0', () {
      container.read(counterControllerProvider.notifier)
        ..increment()
        ..increment()
        ..increment()
        ..reset();
      final counter = container.read(counterControllerProvider);
      expect(counter.value, equals(0));
    });

    test('increment should save state to repository', () async {
      container.read(counterControllerProvider.notifier).increment();
      await Future<void>.delayed(Duration.zero);
      verify(
        () => mockRepository.saveCounter(const Counter(value: 1)),
      ).called(1);
    });

    test('decrement should save state to repository', () async {
      container.read(counterControllerProvider.notifier).decrement();
      await Future<void>.delayed(Duration.zero);
      verify(
        () => mockRepository.saveCounter(const Counter(value: -1)),
      ).called(1);
    });

    test('reset should save state to repository', () async {
      final notifier = container.read(counterControllerProvider.notifier)
        ..increment();
      await Future<void>.delayed(Duration.zero);
      notifier.reset();
      await Future<void>.delayed(Duration.zero);
      verify(
        () => mockRepository.saveCounter(const Counter(value: 0)),
      ).called(1);
    });
  });

  group('Counter entity', () {
    test('increment should increase value by 1', () {
      const counter = Counter(value: 5);
      expect(counter.increment().value, equals(6));
    });

    test('decrement should decrease value by 1', () {
      const counter = Counter(value: 5);
      expect(counter.decrement().value, equals(4));
    });

    test('reset should set value to 0', () {
      const counter = Counter(value: 5);
      expect(counter.reset().value, equals(0));
    });

    test('equality should work correctly', () {
      const counter1 = Counter(value: 5);
      const counter2 = Counter(value: 5);
      const counter3 = Counter(value: 10);
      expect(counter1, equals(counter2));
      expect(counter1, isNot(equals(counter3)));
    });

    test('copyWith should create new instance with updated value', () {
      const counter = Counter(value: 5);
      final updated = counter.copyWith(value: 10);
      expect(updated.value, equals(10));
      expect(counter.value, equals(5));
    });
  });
}
