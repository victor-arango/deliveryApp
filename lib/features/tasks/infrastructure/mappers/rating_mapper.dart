import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';

class RatingMapper {
  static Ratings ratingJsonToEntity(Map<String, dynamic> json) => Ratings(
        taskId: json['task_id'],
        deliveryId: json['delivery_id'],
        rating: json['rating'],
      );
}
