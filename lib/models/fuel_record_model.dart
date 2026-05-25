import '../vendor/uuid.dart';

class FuelRecord {
  final String id;
  final String truckId;
  final String contractId;
  String stationName;
  String stationLocation;
  double amountLiters;
  double costPerLiter;
  double totalCost;
  double odometerReading;
  DateTime purchaseDate;
  String? notes;
  DateTime createdAt;

  FuelRecord({
    String? id,
    required this.truckId,
    required this.contractId,
    required this.stationName,
    required this.stationLocation,
    required this.amountLiters,
    required this.costPerLiter,
    required this.totalCost,
    required this.odometerReading,
    required this.purchaseDate,
    this.notes,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'truckId': truckId,
    'contractId': contractId,
    'stationName': stationName,
    'stationLocation': stationLocation,
    'amountLiters': amountLiters,
    'costPerLiter': costPerLiter,
    'totalCost': totalCost,
    'odometerReading': odometerReading,
    'purchaseDate': purchaseDate.toIso8601String(),
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FuelRecord.fromJson(Map<String, dynamic> json) => FuelRecord(
    id: json['id'],
    truckId: json['truckId'],
    contractId: json['contractId'],
    stationName: json['stationName'],
    stationLocation: json['stationLocation'],
    amountLiters: json['amountLiters'].toDouble(),
    costPerLiter: json['costPerLiter'].toDouble(),
    totalCost: json['totalCost'].toDouble(),
    odometerReading: json['odometerReading'].toDouble(),
    purchaseDate: DateTime.parse(json['purchaseDate']),
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
