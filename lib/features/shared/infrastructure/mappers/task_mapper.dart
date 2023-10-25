import 'package:mensaeria_alv/features/shared/domain/domain.dart';

class TaskMapper {
  static taskJsonToEntity(Map<String, dynamic> json) => Task(
      descripcion: json['descripcion'],
      user_id: json['user_id'],
      delivery_id: json['delivery_id'],
      status: json['status'],
      priority: json['priority'],
      timestamp: json['timestamp']);
}
