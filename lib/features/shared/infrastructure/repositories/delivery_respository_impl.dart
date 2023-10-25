import 'package:mensaeria_alv/features/shared/domain/domain.dart';

class DeliveryRepositoryImpl extends DeliverysRepository {
  final DeliverysDatasource datasource;

  DeliveryRepositoryImpl({required this.datasource});
  @override
  Future<List<Delivery>> getDeliverysById(String id) {
    return datasource.getDeliverysById(id);
  }
}
