import '../vendor/uuid.dart';

class ActivityLog {
  final String id;
  final String? userId;
  String action;
  String entityType;
  String entityId;
  String? details;
  DateTime timestamp;

  ActivityLog({
    String? id,
    this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.details,
    DateTime? timestamp,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'action': action,
    'entityType': entityType,
    'entityId': entityId,
    'details': details,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    id: json['id'],
    userId: json['userId'],
    action: json['action'],
    entityType: json['entityType'],
    entityId: json['entityId'],
    details: json['details'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
