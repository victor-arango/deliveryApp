import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/shared/domain/domain.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/datasource/deliverys_datasource_impl.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/repositories/delivery_respository_impl.dart';

final deliveryRepositoryProvider = Provider<DeliverysRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.session_token ?? '';

  final deliveryRepository = DeliveryRepositoryImpl(
      datasource: DeliveryDatasourceImpl(accessToken: accessToken));

  return deliveryRepository;
});
