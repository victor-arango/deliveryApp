import 'package:dio/dio.dart';
import 'package:mensaeria_alv/config/config.dart';
import 'package:mensaeria_alv/features/delivery/domain/domain.dart';
import 'package:mensaeria_alv/features/delivery/infrasctucture/mappers/task_delivery_mapper.dart';

class TaskDeliveryDatasourceImpl extends TaskDeliveryDatasource {
  late final Dio dio;
  final String accestoken;

  TaskDeliveryDatasourceImpl({required this.accestoken})
      : dio = Dio(BaseOptions(
            baseUrl: Environmet.apiUrl,
            headers: {'Authorization': 'Bearer $accestoken'}));

  @override
  Future<TaskDelivery> finishTask(Map<String, dynamic> taskLike) {
    // TODO: implement finishTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskDelivery>> getTaskByIdAndStatus(
      String userId, String status) async {
    final response =
        await dio.get<List>('/task/findByDeliveryAndStatus/$userId/$status');
    final List<TaskDelivery> tasks = [];
    for (final task in response.data ?? []) {
      tasks.add(TaskDeliveryMapper.jsonToEntity(task));
    }
    return tasks;
  }
}
