import '../vendor/uuid.dart';

class Route {
  final String id;
  final String contractId;
  String name;
  String origin;
  String destination;
  double distance;
  String? estimatedTime;
  String? notes;
  DateTime createdAt;

  Route({
    String? id,
    required this.contractId,
    required this.name,
    required this.origin,
    required this.destination,
    required this.distance,
    this.estimatedTime,
    this.notes,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'name': name,
    'origin': origin,
    'destination': destination,
    'distance': distance,
    'estimatedTime': estimatedTime,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    id: json['id'],
    contractId: json['contractId'],
    name: json['name'],
    origin: json['origin'],
    destination: json['destination'],
    distance: json['distance'].toDouble(),
    estimatedTime: json['estimatedTime'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
