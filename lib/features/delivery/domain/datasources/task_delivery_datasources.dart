import 'package:mensaeria_alv/features/delivery/domain/entities/task_delivery.dart';

abstract class TaskDeliveryDatasource {
  Future<List<TaskDelivery>> getTaskByIdAndStatus(String userId, String status);

  Future<TaskDelivery> finishTask(Map<String, dynamic> taskLike);
}
