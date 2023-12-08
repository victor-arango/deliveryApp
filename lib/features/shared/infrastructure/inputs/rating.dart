import 'package:formz/formz.dart';

// Define input validation errors for Description
enum RatingError { empty }

class Rating extends FormzInput<int, RatingError> {
  // Call super.pure to represent an unmodified form input.
  const Rating.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Rating.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RatingError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RatingError? validator(int value) {
    if (value.isNaN || value == 0) return RatingError.empty;

    return null;
  }
}
