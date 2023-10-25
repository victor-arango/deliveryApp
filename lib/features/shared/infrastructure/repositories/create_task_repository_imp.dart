import 'package:mensaeria_alv/features/shared/domain/domain.dart';

import '../infrastructure.dart';

class CreateTaskRepositoryImpl extends CreateTaskRepository {
  final CreateTaskDatasource datasource;

  CreateTaskRepositoryImpl({CreateTaskDatasource? datasource})
      : datasource = datasource ?? CreateTaskDatasourceImpl();

  @override
  Future<Task> createTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp) {
    return datasource.createTask(
        userId, descripcion, deliveryId, priority, timestamp);
  }

  @override
  Future<Task> updateTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp) {
    return datasource.updateTask(
        userId, descripcion, deliveryId, priority, timestamp);
  }
}
