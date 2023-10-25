import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/inputs/confirm_password.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
  (ref) {
    final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

    return RegisterFormNotifier(registerUserCallback: registerUserCallback);
  },
);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid:
            Formz.validate([newPassword, state.email, state.confirmPassword]));
  }

  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate(
            [newFullName, state.email, state.password, state.confirmPassword]));
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = ConfirmPassword.dirty(
        password: state.password.value,
        value: value); // Usar 'value' directamente
    state = state.copyWith(
        confirmPassword: newConfirmPassword,
        isValid: Formz.validate(
            [newConfirmPassword, state.fullName, state.email, state.password]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    await registerUserCallback(
        state.fullName.value, state.email.value, state.password.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final confirmPassword = ConfirmPassword.dirty(
        password: state.password.value, value: state.confirmPassword.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        fullName: fullName,
        confirmPassword: confirmPassword,
        isValid: Formz.validate([email, password, fullName, confirmPassword]));
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final Email email;
  final Password password;
  final FullName fullName;
  final ConfirmPassword confirmPassword;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.fullName = const FullName.pure(),
      this.confirmPassword = const ConfirmPassword.pure()});

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    FullName? fullName,
    ConfirmPassword? confirmPassword,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );

  @override
  String toString() {
    return '''  
        loginFormState:
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
        name: $fullName
        confirmPassword: $confirmPassword
        
    ''';
  }
}
