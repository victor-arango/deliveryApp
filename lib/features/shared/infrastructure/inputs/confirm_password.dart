import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { invalid, mismatch }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.invalid;
    return password == value ? null : ConfirmPasswordValidationError.mismatch;
  }

  String? get errorMessage {
    if (error == ConfirmPasswordValidationError.invalid) {
      return 'El campo es requerido';
    } else if (error == ConfirmPasswordValidationError.mismatch) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
