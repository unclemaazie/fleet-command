import '../vendor/uuid.dart';

class Driver {
  final String id;
  final String contractId;
  String name;
  String email;
  String phone;
  String licenseNumber;
  String licenseType;
  DateTime licenseExpiry;
  String status;
  String? assignedTruckId;
  String? emergencyContact;
  String? address;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Driver({
    String? id,
    required this.contractId,
    required this.name,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.licenseType,
    required this.licenseExpiry,
    this.status = 'active',
    this.assignedTruckId,
    this.emergencyContact,
    this.address,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'name': name,
    'email': email,
    'phone': phone,
    'licenseNumber': licenseNumber,
    'licenseType': licenseType,
    'licenseExpiry': licenseExpiry.toIso8601String(),
    'status': status,
    'assignedTruckId': assignedTruckId,
    'emergencyContact': emergencyContact,
    'address': address,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'],
    contractId: json['contractId'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    licenseNumber: json['licenseNumber'],
    licenseType: json['licenseType'],
    licenseExpiry: DateTime.parse(json['licenseExpiry']),
    status: json['status'],
    assignedTruckId: json['assignedTruckId'],
    emergencyContact: json['emergencyContact'],
    address: json['address'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
