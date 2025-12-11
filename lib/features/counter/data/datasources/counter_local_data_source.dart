import '../../domain/entities/counter.dart';

abstract class CounterLocalDataSource {
  Future<Counter> getCounter();
  Future<void> saveCounter(Counter counter);
  Future<void> clearCounter();
}

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  CounterLocalDataSourceImpl();

  int _cachedValue = 0;

  @override
  Future<Counter> getCounter() async {
    return Counter(value: _cachedValue);
  }

  @override
  Future<void> saveCounter(Counter counter) async {
    _cachedValue = counter.value;
  }

  @override
  Future<void> clearCounter() async {
    _cachedValue = 0;
  }
}
