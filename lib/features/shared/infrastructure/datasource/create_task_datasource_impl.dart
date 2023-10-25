import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mensaeria_alv/config/constants/environment.dart';
import 'package:mensaeria_alv/features/auth/infrastructure/infrasctuture.dart';
import 'package:mensaeria_alv/features/shared/domain/domain.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/infrastructure.dart';

class CreateTaskDatasourceImpl extends CreateTaskDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environmet.apiUrl));

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<Task> createTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp) async {
    try {
      final response = await dio.post('/task/create', data: {
        'user_id': userId,
        'descripcion': descripcion,
        'delivery_id': deliveryId,
        'priority': priority,
        'timestamp': timestamp
      });

      final task = TaskMapper.taskJsonToEntity(response.data['data']);
      Fluttertoast.showToast(msg: response.data['message']);
      return task;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('No se pudo crear la tarea');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      throw CustomError('Error desconocido');
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Task> updateTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
