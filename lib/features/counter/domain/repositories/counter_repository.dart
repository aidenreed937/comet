import '../entities/counter.dart';

abstract class CounterRepository {
  Future<Counter> getCounter();
  Future<void> saveCounter(Counter counter);
  Future<void> clearCounter();
}
