import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';

class CounterRepositoryImpl implements CounterRepository {
  CounterRepositoryImpl({required this.localDataSource});

  final CounterLocalDataSource localDataSource;

  @override
  Future<Counter> getCounter() async {
    return localDataSource.getCounter();
  }

  @override
  Future<void> saveCounter(Counter counter) async {
    await localDataSource.saveCounter(counter);
  }

  @override
  Future<void> clearCounter() async {
    await localDataSource.clearCounter();
  }
}
