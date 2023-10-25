import 'package:dio/dio.dart';
import 'package:mensaeria_alv/config/constants/environment.dart';
import 'package:mensaeria_alv/features/shared/domain/domain.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/mappers/delivery_mapper.dart';

class DeliveryDatasourceImpl extends DeliverysDatasource {
  late final Dio dio;
  final String accessToken;

  DeliveryDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environmet.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<List<Delivery>> getDeliverysById(String id) async {
    final response = await dio.get<List>('/auth/findByDeliveryMen');
    final List<Delivery> deliverys = [];
    for (final deliveryData in response.data ?? []) {
      deliverys.add(DeliveryMapper.jsonToEntity(deliveryData));
    }
    return deliverys;
  }
}
