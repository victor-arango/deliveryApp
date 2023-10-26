import 'package:mensaeria_alv/features/tareas/domain/entities/task_user.dart';

abstract class TaskUserDatasource {
  Future<List<TaskUser>> getTaskByIdAndStatus(int userId, String status);
  Future<TaskUser> getTaskById(String id);
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike);
}
