class TaskDelivery {
  String id;
  String userId;
  String deliveryId;
  String descripcion;
  String status;
  String timestamp;
  String priority;

  TaskDelivery({
    required this.id,
    required this.userId,
    required this.deliveryId,
    required this.descripcion,
    required this.status,
    required this.timestamp,
    required this.priority,
  });

  map(Function(dynamic element) param0) {}
}
