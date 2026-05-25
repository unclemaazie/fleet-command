import '../vendor/uuid.dart';

class Contract {
  final String id;
  String name;
  String clientName;
  String clientEmail;
  String clientPhone;
  String? clientAddress;
  DateTime startDate;
  DateTime endDate;
  String status;
  double? budget;
  String? description;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Contract({
    String? id,
    required this.name,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    this.clientAddress,
    required this.startDate,
    required this.endDate,
    this.status = 'active',
    this.budget,
    this.description,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clientName': clientName,
    'clientEmail': clientEmail,
    'clientPhone': clientPhone,
    'clientAddress': clientAddress,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'status': status,
    'budget': budget,
    'description': description,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
    id: json['id'],
    name: json['name'],
    clientName: json['clientName'],
    clientEmail: json['clientEmail'],
    clientPhone: json['clientPhone'],
    clientAddress: json['clientAddress'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    status: json['status'],
    budget: json['budget']?.toDouble(),
    description: json['description'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
