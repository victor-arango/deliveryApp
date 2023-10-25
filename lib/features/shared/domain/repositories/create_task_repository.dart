import '../entities/task.dart';

abstract class CreateTaskRepository {
  Future<Task> createTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp);
  Future<Task> updateTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp);
  // Future<Task> valorateTask(String userId, String deliveryId, String status,
  //     String priority, String timestamp);
}
