import 'package:mensaeria_alv/features/shared/domain/entities/delivery.dart';

abstract class DeliverysDatasource {
  Future<List<Delivery>> getDeliverysById(String id);
}
