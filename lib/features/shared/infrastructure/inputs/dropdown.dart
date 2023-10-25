import 'package:formz/formz.dart';

// Define input validation errors for Description
enum DropdowError { empty }

class Dropdow extends FormzInput<int, DropdowError> {
  // Call super.pure to represent an unmodified form input.
  const Dropdow.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Dropdow.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DropdowError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DropdowError? validator(int value) {
    if (value.isNaN || value == 0) return DropdowError.empty;

    return null;
  }
}
