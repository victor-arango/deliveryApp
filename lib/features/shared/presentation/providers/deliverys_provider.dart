//State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/shared/domain/domain.dart';
import 'deliverys_repository_provider.dart';

final deliverysProvider =
    StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  final deliveryRepository = ref.watch(deliveryRepositoryProvider);

  return DeliveryNotifier(deliverysRepository: deliveryRepository);
});

//Notifier

class DeliveryNotifier extends StateNotifier<DeliveryState> {
  final DeliverysRepository deliverysRepository;
  bool _isLoaded = false; // Variable para rastrear si ya se cargaron los datos.

  DeliveryNotifier({required this.deliverysRepository})
      : super(DeliveryState());

  Future loadDelivery() async {
    // Verifica si ya se cargaron los datos.
    if (_isLoaded) return;

    // Realiza la petición.

    final deliverys = await deliverysRepository.getDeliverysById("3");
    if (deliverys.isEmpty) {
      state = state.copyWith(isLoading: false);
      _isLoaded = true; // Marca la petición como completada.
      return;
    }
    state = state.copyWith(
      deliverys: [
        ...state.deliverys,
        ...deliverys,
      ],
      isLoading: false,
    );
    _isLoaded = true; // Marca la petición como completada.
  }
}

//State
class DeliveryState {
  final List<Delivery> deliverys;
  final bool isLoading;
  final bool petition;

  DeliveryState(
      {this.deliverys = const [],
      this.isLoading = false,
      this.petition = true});

  DeliveryState copyWith({
    List<Delivery>? deliverys,
    bool? isLoading,
    bool? petition,
  }) =>
      DeliveryState(
          deliverys: deliverys ?? this.deliverys,
          isLoading: isLoading ?? this.isLoading,
          petition: petition ?? this.petition);
}
