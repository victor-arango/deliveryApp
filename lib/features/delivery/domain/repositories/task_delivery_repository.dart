import 'package:mensaeria_alv/features/delivery/domain/entities/task_delivery.dart';

abstract class TaskDeliveryRepository {
  Future<List<TaskDelivery>> getTaskById(String userId);

  Future<TaskDelivery> finishTask(Map<String, dynamic> taskLike);
}
