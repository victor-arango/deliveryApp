import 'package:mensaeria_alv/features/tareas/domain/domain.dart';

class TaskUserRepositoryImpl extends TaskUserRepository {
  final TaskUserDatasource datasource;

  TaskUserRepositoryImpl(this.datasource);

  @override
  Future<TaskUser> getTaskById(String id) {
    return datasource.getTaskById(id);
  }

  @override
  Future<List<TaskUser>> getTaskByIdAndStatus(int userId, String status) {
    return datasource.getTaskByIdAndStatus(userId, status);
  }

  @override
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike) {
    return datasource.updateTask(taskLike);
  }
}
