class User {
  final String id;
  final String fullname;
  final String email;
  final List<String> roles;
  final String sessionToken;

  User(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.roles,
      required this.sessionToken});

  bool get isAdmin {
    return roles.contains('admin');
  }

  bool get isDelivery {
    return roles.contains('delivery');
  }
}
