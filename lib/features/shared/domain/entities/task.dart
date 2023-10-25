class Task {
  final String descripcion;
  final String user_id;
  final String delivery_id;
  final String? status;
  final String priority;
  final String timestamp;

  Task({
    required this.descripcion,
    required this.user_id,
    required this.delivery_id,
    this.status,
    required this.priority,
    required this.timestamp,
  });
}
