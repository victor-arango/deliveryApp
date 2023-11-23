import 'package:formz/formz.dart';

// Define input validation errors for FullName
enum FullNameError { empty }

class FullName extends FormzInput<String, FullNameError> {
  // Call super.pure to represent an unmodified form input.
  const FullName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FullName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == FullNameError.empty) {
      return 'El campo de nombre completo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  FullNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullNameError.empty;

    return null;
  }
}
