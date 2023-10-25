import 'package:formz/formz.dart';

// Define input validation errors for Description
enum DropdowDateError { empty }

class DropdowDate extends FormzInput<String, DropdowDateError> {
  // Call super.pure to represent an unmodified form input.
  const DropdowDate.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const DropdowDate.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DropdowDateError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DropdowDateError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return DropdowDateError.empty;

    return null;
  }
}
