import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/infrastructure/mappers/rating_mapper.dart';

class TaskUserMapper {
  static TaskUser jsonToEntity(Map<String, dynamic> json) {
    return TaskUser(
        id: json['id'],
        userId: json['user_id'],
        deliveryId: json['delivery_id'],
        descripcion: json['descripcion'],
        status: json['status'],
        timestamp: json['timestamp'],
        priority: json['priority'],
        ratings: RatingMapper.ratingJsonToEntity(json['ratings']));
  }
}
