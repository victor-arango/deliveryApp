class TaskUser {
  String id;
  String userId;
  String deliveryId;
  String descripcion;
  String status;
  String timestamp;
  String priority;
  Ratings ratings;

  TaskUser({
    required this.id,
    required this.userId,
    required this.deliveryId,
    required this.descripcion,
    required this.status,
    required this.timestamp,
    required this.priority,
    required this.ratings,
  });
}

class Ratings {
  int taskId;
  int deliveryId;
  int rating;

  Ratings({
    required this.taskId,
    required this.deliveryId,
    required this.rating,
  });
}
