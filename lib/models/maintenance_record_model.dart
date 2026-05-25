import '../vendor/uuid.dart';

class MaintenanceRecord {
  final String id;
  final String truckId;
  final String contractId;
  String serviceType;
  String description;
  String serviceProvider;
  double cost;
  DateTime serviceDate;
  DateTime? nextServiceDate;
  double? nextServiceOdometer;
  String status;
  String? partsReplaced;
  String? notes;
  DateTime createdAt;

  MaintenanceRecord({
    String? id,
    required this.truckId,
    required this.contractId,
    required this.serviceType,
    required this.description,
    required this.serviceProvider,
    required this.cost,
    required this.serviceDate,
    this.nextServiceDate,
    this.nextServiceOdometer,
    this.status = 'completed',
    this.partsReplaced,
    this.notes,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'truckId': truckId,
    'contractId': contractId,
    'serviceType': serviceType,
    'description': description,
    'serviceProvider': serviceProvider,
    'cost': cost,
    'serviceDate': serviceDate.toIso8601String(),
    'nextServiceDate': nextServiceDate?.toIso8601String(),
    'nextServiceOdometer': nextServiceOdometer,
    'status': status,
    'partsReplaced': partsReplaced,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => MaintenanceRecord(
    id: json['id'],
    truckId: json['truckId'],
    contractId: json['contractId'],
    serviceType: json['serviceType'],
    description: json['description'],
    serviceProvider: json['serviceProvider'],
    cost: json['cost'].toDouble(),
    serviceDate: DateTime.parse(json['serviceDate']),
    nextServiceDate: json['nextServiceDate'] != null ? DateTime.parse(json['nextServiceDate']) : null,
    nextServiceOdometer: json['nextServiceOdometer']?.toDouble(),
    status: json['status'],
    partsReplaced: json['partsReplaced'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
