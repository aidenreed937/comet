import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_notifier.dart';
import 'login_state.dart';

export 'login_form_state.dart';
export 'login_state.dart';

/// Dio provider alias
final dioProvider = dioClientProvider;

/// Storage provider alias
final storageProvider = keyValueStorageProvider;

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  final tokenManager = ref.watch(authTokenManagerProvider);

  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(dioClient.dio),
    storage: storage,
    tokenManager: tokenManager,
  );
});

/// Login notifier provider
final loginProvider = NotifierProvider<LoginNotifier, LoginState>(() {
  return LoginNotifier();
});
