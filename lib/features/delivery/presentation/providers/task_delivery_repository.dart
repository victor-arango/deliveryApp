import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/delivery/infrasctucture/datasources/task_delivery_datasources_impl.dart';
import 'package:mensaeria_alv/features/delivery/infrasctucture/repositories/task_delivery_repository_impl.dart';

final taskDeliveryRespositoryProvider = Provider((ref) {
  final accessToken = ref.watch(authProvider).user?.sessionToken ?? '';

  final taskDeliveryRepository = TaskDeliveryRepositoryImpl(
      TaskDeliveryDatasourceImpl(accestoken: accessToken));

  return taskDeliveryRepository;
});
