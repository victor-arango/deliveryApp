import 'package:mensaeria_alv/features/shared/domain/entities/delivery.dart';

class DeliveryMapper {
  static jsonToEntity(Map<String, dynamic> json) => Delivery(
      id: json['id'], email: json['email'], fullname: json['fullname']);
}
