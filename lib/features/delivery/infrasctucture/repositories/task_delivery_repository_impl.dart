import 'package:mensaeria_alv/features/delivery/domain/domain.dart';

class TaskDeliveryRepositoryImpl extends TaskDeliveryRepository {
  final TaskDeliveryDatasource datasource;

  TaskDeliveryRepositoryImpl(this.datasource);

  @override
  Future<TaskDelivery> finishTask(Map<String, dynamic> taskLike) {
    return datasource.finishTask(taskLike);
  }

  @override
  Future<List<TaskDelivery>> getTaskByIdAndStatus(
      String userId, String status) {
    return datasource.getTaskByIdAndStatus(userId, status);
  }
}
