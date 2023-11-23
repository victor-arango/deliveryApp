import 'package:formz/formz.dart';

// Define input validation errors for Description
enum DropdowPriorityError { empty }

class DropdowPriority extends FormzInput<String, DropdowPriorityError> {
  // Call super.pure to represent an unmodified form input.
  const DropdowPriority.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const DropdowPriority.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DropdowPriorityError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DropdowPriorityError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return DropdowPriorityError.empty;
    }

    return null;
  }
}
