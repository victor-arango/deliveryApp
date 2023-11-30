import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';

abstract class TaskUserDatasource {
  Future<List<TaskUser>> getTaskByIdAndStatus(String userId, String status);
  Future<TaskUser> getTaskById(String id);
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike);
  Future<TaskUser> updateRatingTask(Map<String, dynamic> taskLike);
}
