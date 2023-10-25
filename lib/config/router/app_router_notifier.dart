import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/domain.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  User? _user; // Cambia el nombre de la propiedad

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
      user = state.user;
    });
  }

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

  set user(User? value) {
    _user = value;
    notifyListeners();
  }
}
