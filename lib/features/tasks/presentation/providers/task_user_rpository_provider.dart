import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/infrastructure/infrastucture.dart';

final taskUserRepositoyProvider = Provider<TaskUserRepository>((ref) {
  final accesToken = ref.watch(authProvider).user?.session_token ?? '';

  final taskUserRepository =
      TaskUserRepositoryImpl(TaskUserDatasourceImpl(accestoken: accesToken));

  return taskUserRepository;
});
