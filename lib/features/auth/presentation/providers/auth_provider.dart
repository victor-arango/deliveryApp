import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/domain.dart';
import 'package:mensaeria_alv/features/auth/infrastructure/infrasctuture.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStroageServiceImp();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setUserInState(user);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      // print(e);
      logout('Error no controlado');
    }
  }

  Future<void> registerUser(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      final user = await authRepository.register(fullname, email, password);

      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

//Valida el estado del token

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setUserInState(user);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setUserInState(User user) {
    state = state.copyWith(user: user);
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.sessionToken);
    await keyValueStorageService.setKeyValue('idUser', user.id);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeValue('token');
    await keyValueStorageService.removeValue('idUser');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
