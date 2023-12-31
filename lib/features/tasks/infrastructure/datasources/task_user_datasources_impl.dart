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
  Future<List<TaskUser>> getTaskByIdAndStatus(
      String userId, String status) async {
    final response =
        await dio.get<List>('/task/findByClientAndStatus/$userId/$status');

    final List<TaskUser> tasks = [];
    for (final task in response.data ?? []) {
      tasks.add(TaskUserMapper.jsonToEntity(task));
    }
    return tasks;
  }

  @override
  Future<TaskUser> updateTask(Map<String, dynamic> taskLike) async {
    try {
      final String? taskId = taskLike['id'];
      final String method = (taskId == null) ? 'POST' : 'PATCH';
      final String url = (taskId == null) ? '/task/create' : '/task/$taskId';

      taskLike.remove('id');

      final response = await dio.request(url,
          data: taskLike, options: Options(method: method));

      final task = TaskUserMapper.jsonToEntity(response.data['data']);

      return task;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<TaskUser> updateRatingTask(Map<String, dynamic> taskLike) async {
    try {
      final String? taskId = taskLike['id'];
      final Map<String, dynamic>? ratings = taskLike['ratings'];
      final int? rating = ratings?['rating'];
      final response =
          await dio.patch('/task/updateTaskByIdAndStatus/$taskId/$rating');
      final task = TaskUserMapper.jsonToEntity(response.data['data']);

      return task;
    } catch (e) {
      throw Exception();
    }
  }
}
