import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mensaeria_alv/config/config.dart';
import 'package:mensaeria_alv/features/auth/domain.dart';
import 'package:mensaeria_alv/features/auth/infrastructure/infrasctuture.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environmet.apiUrl));

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));

      print(response);

      final user = UserMapper.userJsonToEntity(response.data['data']);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
        throw CustomError('Token incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});
      final responseData = response.data;
      final user = UserMapper.userJsonToEntity(responseData['data']);
      Fluttertoast.showToast(msg: response.data['message']);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post('/auth/register',
          data: {
            'fullname': fullname,
            'email': email,
            'password': password,
          },
          options: Options(headers: headers));
      Fluttertoast.showToast(msg: response.data['message']);

      final user = UserMapper.userJsonToEntity(response.data['data']);
      return user;
    } on DioException catch (e) {
      if (e.response?.data == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Revisa los datos proporcionados');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Resvisa la conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
