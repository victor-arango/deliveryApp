import 'package:dio/dio.dart';
import 'package:mensaeria_alv/config/constants/environment.dart';
import 'package:mensaeria_alv/features/tareas/domain/domain.dart';
import 'package:mensaeria_alv/features/tareas/infrastructure/mappers/task_user_mapper.dart';

class TaskUserDatasourceImpl extends TaskUserDatasource {
  late final Dio dio;
  final String accestoken;

  TaskUserDatasourceImpl({required this.accestoken})
      : dio = Dio(BaseOptions(
            baseUrl: Environmet.apiUrl,
            headers: {'Authorization': 'Bearer $accestoken'}));

  @override
  Future<TaskUser> getTaskById(String id) {
    // TODO: implement getTaskById
    throw UnimplementedError();
  }

  @override
  Future<List<TaskUser>> getTaskByIdAndStatus(int userId, String status) async {
    final response =
        await dio.get<List>('/task/findByClientAndStatus/$userId/$status');
    print(response.data);
    final List<TaskUser> tasks = [];
    for (final task in response.data ?? []) {
      tasks.add(TaskUserMapper.jsonToEntity(task));

      print(task);
    }
    return tasks;
  }

  @override
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
