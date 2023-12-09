import '../../domain/domain.dart';

class TaskDeliveryMapper {
  static TaskDelivery jsonToEntity(Map<String, dynamic> json) {
    return TaskDelivery(
      id: json['id'],
      userId: json['user_id'],
      deliveryId: json['delivery_id'],
      descripcion: json['descripcion'],
      status: json['status'],
      timestamp: json['timestamp'],
      priority: json['priority'],
    );
  }
}
