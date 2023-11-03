import 'package:dio/dio.dart';
import 'package:mensaeria_alv/config/constants/environment.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/infrastructure/mappers/task_user_mapper.dart';

import '../errors/task_errors.dart';

class TaskUserDatasourceImpl extends TaskUserDatasource {
  late final Dio dio;
  final String accestoken;

  TaskUserDatasourceImpl({required this.accestoken})
      : dio = Dio(BaseOptions(
            baseUrl: Environmet.apiUrl,
            headers: {'Authorization': 'Bearer $accestoken'}));

  @override
  Future<TaskUser> getTaskById(String id) async {
    try {
      final response = await dio.get('/task/findTaskById/$id');
      final task = TaskUserMapper.jsonToEntity(response.data);
      return task;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw TaskNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<TaskUser>> getTaskByIdAndStatus(int userId, String status) async {
    final response =
        await dio.get<List>('/task/findByClientAndStatus/$userId/$status');
    final List<TaskUser> tasks = [];
    for (final task in response.data ?? []) {
      tasks.add(TaskUserMapper.jsonToEntity(task));
    }
    return tasks;
  }

  @override
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
