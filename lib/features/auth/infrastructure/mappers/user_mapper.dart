import 'package:mensaeria_alv/features/auth/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      sessionToken: json['session_token']);
}
