import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/counter_local_data_source.dart';
import '../../data/repositories/counter_repository_impl.dart';
import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';

final counterLocalDataSourceProvider = Provider<CounterLocalDataSource>((ref) {
  return CounterLocalDataSourceImpl();
});

final counterRepositoryProvider = Provider<CounterRepository>((ref) {
  return CounterRepositoryImpl(
    localDataSource: ref.watch(counterLocalDataSourceProvider),
  );
});

final counterControllerProvider = NotifierProvider<CounterController, Counter>(
  CounterController.new,
);

class CounterController extends Notifier<Counter> {
  @override
  Counter build() {
    return const Counter(value: 0);
  }

  CounterRepository get _repository => ref.read(counterRepositoryProvider);

  void increment() {
    state = state.increment();
    _saveState();
  }

  void decrement() {
    state = state.decrement();
    _saveState();
  }

  void reset() {
    state = state.reset();
    _saveState();
  }

  Future<void> _saveState() async {
    await _repository.saveCounter(state);
  }
}
