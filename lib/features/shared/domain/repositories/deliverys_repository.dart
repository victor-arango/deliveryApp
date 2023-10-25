import 'package:mensaeria_alv/features/shared/domain/entities/delivery.dart';

abstract class DeliverysRepository {
  Future<List<Delivery>> getDeliverysById(String id);
}
