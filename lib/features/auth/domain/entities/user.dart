class User {
  final String id;
  final String fullname;
  final String email;
  final List<String> roles;
  final String session_token;

  User(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.roles,
      required this.session_token});

  bool get isAdmin {
    return roles.contains('admin');
  }

  bool get isDelivery {
    return roles.contains('delivery');
  }
}
