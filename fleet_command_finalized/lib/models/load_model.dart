import '../vendor/uuid.dart';

class Load {
  final String id;
  final String truckId;
  final String contractId;
  String productName;
  String pickupLocation;
  String dropoffLocation;
  String? pickupContact;
  String? dropoffContact;
  double weight;
  double price;
  String status;
  DateTime pickupDate;
  DateTime? deliveryDate;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Load({
    String? id,
    required this.truckId,
    required this.contractId,
    required this.productName,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.pickupContact,
    this.dropoffContact,
    required this.weight,
    required this.price,
    this.status = 'pending',
    required this.pickupDate,
    this.deliveryDate,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'truckId': truckId,
    'contractId': contractId,
    'productName': productName,
    'pickupLocation': pickupLocation,
    'dropoffLocation': dropoffLocation,
    'pickupContact': pickupContact,
    'dropoffContact': dropoffContact,
    'weight': weight,
    'price': price,
    'status': status,
    'pickupDate': pickupDate.toIso8601String(),
    'deliveryDate': deliveryDate?.toIso8601String(),
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    id: json['id'],
    truckId: json['truckId'],
    contractId: json['contractId'],
    productName: json['productName'],
    pickupLocation: json['pickupLocation'],
    dropoffLocation: json['dropoffLocation'],
    pickupContact: json['pickupContact'],
    dropoffContact: json['dropoffContact'],
    weight: json['weight'].toDouble(),
    price: json['price'].toDouble(),
    status: json['status'],
    pickupDate: DateTime.parse(json['pickupDate']),
    deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
