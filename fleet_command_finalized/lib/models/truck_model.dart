import '../vendor/uuid.dart';

class Truck {
  final String id;
  final String contractId;
  String registrationNumber;
  String make;
  String model;
  int year;
  String status;
  double odometer;
  String? driverId;
  String? currentLoadId;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Truck({
    String? id,
    required this.contractId,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    this.status = 'active',
    this.odometer = 0.0,
    this.driverId,
    this.currentLoadId,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'registrationNumber': registrationNumber,
    'make': make,
    'model': model,
    'year': year,
    'status': status,
    'odometer': odometer,
    'driverId': driverId,
    'currentLoadId': currentLoadId,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Truck.fromJson(Map<String, dynamic> json) => Truck(
    id: json['id'],
    contractId: json['contractId'],
    registrationNumber: json['registrationNumber'],
    make: json['make'],
    model: json['model'],
    year: json['year'],
    status: json['status'],
    odometer: json['odometer'].toDouble(),
    driverId: json['driverId'],
    currentLoadId: json['currentLoadId'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
