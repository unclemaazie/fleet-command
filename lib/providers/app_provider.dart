import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/contract_model.dart';
import '../models/truck_model.dart';
import '../models/driver_model.dart';
import '../models/fuel_record_model.dart';
import '../models/maintenance_record_model.dart';
import '../models/load_model.dart';
import '../models/route_model.dart';
import '../models/activity_log_model.dart';

class AppProvider extends ChangeNotifier {
  List<Contract> _contracts = [];
  List<Truck> _trucks = [];
  List<Driver> _drivers = [];
  List<FuelRecord> _fuelRecords = [];
  List<MaintenanceRecord> _maintenanceRecords = [];
  List<Load> _loads = [];
  List<Route> _routes = [];
  List<ActivityLog> _activityLogs = [];

  // Getters
  List<Contract> get contracts => _contracts;
  List<Truck> get trucks => _trucks;
  List<Driver> get drivers => _drivers;
  List<FuelRecord> get fuelRecords => _fuelRecords;
  List<MaintenanceRecord> get maintenanceRecords => _maintenanceRecords;
  List<Load> get loads => _loads;
  List<Route> get routes => _routes;
  List<ActivityLog> get activityLogs => _activityLogs;

  int get totalTrucks => _trucks.length;
  int get activeTrucks => _trucks.where((t) => t.status == 'active').length;
  int get totalDrivers => _drivers.length;
  int get activeContracts => _contracts.where((c) => c.status == 'active').length;
  int get pendingLoads => _loads.where((l) => l.status == 'pending').length;
  int get completedLoads => _loads.where((l) => l.status == 'delivered').length;

  double get totalFuelCost => _fuelRecords.fold(0, (sum, r) => sum + r.totalCost);
  double get totalMaintenanceCost => _maintenanceRecords.fold(0, (sum, r) => sum + r.cost);
  double get totalLoadRevenue => _loads.where((l) => l.status == 'delivered').fold(0, (sum, l) => sum + l.price);

  List<Truck> getTrucksByContract(String contractId) =>
      _trucks.where((t) => t.contractId == contractId).toList();

  List<Driver> getDriversByContract(String contractId) =>
      _drivers.where((d) => d.contractId == contractId).toList();

  List<FuelRecord> getFuelRecordsByTruck(String truckId) =>
      _fuelRecords.where((r) => r.truckId == truckId).toList();

  List<FuelRecord> getFuelRecordsByContract(String contractId) =>
      _fuelRecords.where((r) => r.contractId == contractId).toList();

  List<MaintenanceRecord> getMaintenanceRecordsByTruck(String truckId) =>
      _maintenanceRecords.where((r) => r.truckId == truckId).toList();

  List<Load> getLoadsByTruck(String truckId) =>
      _loads.where((l) => l.truckId == truckId).toList();

  List<Load> getLoadsByContract(String contractId) =>
      _loads.where((l) => l.contractId == contractId).toList();

  List<Route> getRoutesByContract(String contractId) =>
      _routes.where((r) => r.contractId == contractId).toList();

  Driver? getDriverById(String id) => _drivers.firstWhere(
    (d) => d.id == id,
    orElse: () => null as Driver,
  );

  Truck? getTruckById(String id) => _trucks.firstWhere(
    (t) => t.id == id,
    orElse: () => null as Truck,
  );

  Contract? getContractById(String id) => _contracts.firstWhere(
    (c) => c.id == id,
    orElse: () => null as Contract,
  );

  void initializeDemoData() {
    // Create contracts
    final contract1 = Contract(
      id: 'contract_001',
      name: 'Logistics Alpha',
      clientName: 'Alpha Corp',
      clientEmail: 'contact@alphacorp.com',
      clientPhone: '+1-555-0101',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: DateTime.now().add(const Duration(days: 270)),
      status: 'active',
      budget: 500000,
      description: 'Long-haul freight transportation',
    );

    final contract2 = Contract(
      id: 'contract_002',
      name: 'Supply Chain Beta',
      clientName: 'Beta Industries',
      clientEmail: 'ops@betaind.com',
      clientPhone: '+1-555-0102',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 300)),
      status: 'active',
      budget: 350000,
      description: 'Regional distribution services',
    );

    _contracts = [contract1, contract2];

    // Create trucks
    final truck1 = Truck(
      id: 'truck_001',
      contractId: 'contract_001',
      registrationNumber: 'TRK-2024-001',
      make: 'Volvo',
      model: 'FH16',
      year: 2023,
      status: 'active',
      odometer: 45200,
    );

    final truck2 = Truck(
      id: 'truck_002',
      contractId: 'contract_001',
      registrationNumber: 'TRK-2024-002',
      make: 'Mercedes-Benz',
      model: 'Actros',
      year: 2023,
      status: 'active',
      odometer: 38900,
    );

    final truck3 = Truck(
      id: 'truck_003',
      contractId: 'contract_002',
      registrationNumber: 'TRK-2024-003',
      make: 'Scania',
      model: 'R500',
      year: 2022,
      status: 'maintenance',
      odometer: 67800,
    );

    final truck4 = Truck(
      id: 'truck_004',
      contractId: 'contract_002',
      registrationNumber: 'TRK-2024-004',
      make: 'MAN',
      model: 'TGX',
      year: 2023,
      status: 'active',
      odometer: 23400,
    );

    _trucks = [truck1, truck2, truck3, truck4];

    // Create drivers
    final driver1 = Driver(
      id: 'driver_001',
      contractId: 'contract_001',
      name: 'John Smith',
      email: 'john.smith@fleet.com',
      phone: '+1-555-1001',
      licenseNumber: 'DL-2024-001',
      licenseType: 'Class A CDL',
      licenseExpiry: DateTime.now().add(const Duration(days: 365)),
      assignedTruckId: 'truck_001',
    );

    final driver2 = Driver(
      id: 'driver_002',
      contractId: 'contract_001',
      name: 'Sarah Johnson',
      email: 'sarah.j@fleet.com',
      phone: '+1-555-1002',
      licenseNumber: 'DL-2024-002',
      licenseType: 'Class A CDL',
      licenseExpiry: DateTime.now().add(const Duration(days: 180)),
      assignedTruckId: 'truck_002',
    );

    final driver3 = Driver(
      id: 'driver_003',
      contractId: 'contract_002',
      name: 'Mike Davis',
      email: 'mike.d@fleet.com',
      phone: '+1-555-1003',
      licenseNumber: 'DL-2024-003',
      licenseType: 'Class B CDL',
      licenseExpiry: DateTime.now().add(const Duration(days: 90)),
    );

    final driver4 = Driver(
      id: 'driver_004',
      contractId: 'contract_002',
      name: 'Emily Wilson',
      email: 'emily.w@fleet.com',
      phone: '+1-555-1004',
      licenseNumber: 'DL-2024-004',
      licenseType: 'Class A CDL',
      licenseExpiry: DateTime.now().add(const Duration(days: 200)),
      assignedTruckId: 'truck_004',
    );

    _drivers = [driver1, driver2, driver3, driver4];

    // Update truck driver assignments
    truck1.driverId = 'driver_001';
    truck2.driverId = 'driver_002';
    truck4.driverId = 'driver_004';

    // Create fuel records
    final random = Random();
    for (int i = 0; i < 30; i++) {
      final truck = _trucks[random.nextInt(_trucks.length)];
      _fuelRecords.add(FuelRecord(
        truckId: truck.id,
        contractId: truck.contractId,
        stationName: ['Shell', 'BP', 'Exxon', 'Chevron', 'Mobil'][random.nextInt(5)],
        stationLocation: ['New York', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia'][random.nextInt(5)],
        amountLiters: 150 + random.nextDouble() * 350,
        costPerLiter: 1.20 + random.nextDouble() * 0.80,
        totalCost: 0,
        odometerReading: truck.odometer + random.nextDouble() * 1000,
        purchaseDate: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      ));
    }

    // Calculate total costs for fuel records
    for (var record in _fuelRecords) {
      record.totalCost = record.amountLiters * record.costPerLiter;
    }

    // Create maintenance records
    _maintenanceRecords = [
      MaintenanceRecord(
        truckId: 'truck_001',
        contractId: 'contract_001',
        serviceType: 'Oil Change',
        description: 'Regular oil and filter replacement',
        serviceProvider: 'Quick Lube Pro',
        cost: 250.00,
        serviceDate: DateTime.now().subtract(const Duration(days: 15)),
        nextServiceDate: DateTime.now().add(const Duration(days: 90)),
        nextServiceOdometer: 50000,
      ),
      MaintenanceRecord(
        truckId: 'truck_002',
        contractId: 'contract_001',
        serviceType: 'Tire Replacement',
        description: 'Replaced all 6 tires',
        serviceProvider: 'TireMax Services',
        cost: 1800.00,
        serviceDate: DateTime.now().subtract(const Duration(days: 45)),
        nextServiceDate: DateTime.now().add(const Duration(days: 180)),
      ),
      MaintenanceRecord(
        truckId: 'truck_003',
        contractId: 'contract_002',
        serviceType: 'Engine Repair',
        description: 'Turbocharger replacement and engine tune-up',
        serviceProvider: 'Diesel Specialists',
        cost: 4500.00,
        serviceDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'in_progress',
        nextServiceDate: DateTime.now().add(const Duration(days: 30)),
      ),
      MaintenanceRecord(
        truckId: 'truck_004',
        contractId: 'contract_002',
        serviceType: 'Brake Service',
        description: 'Brake pad and rotor replacement',
        serviceProvider: 'Brake Masters',
        cost: 800.00,
        serviceDate: DateTime.now().subtract(const Duration(days: 20)),
        nextServiceDate: DateTime.now().add(const Duration(days: 120)),
      ),
    ];

    // Create loads
    _loads = [
      Load(
        truckId: 'truck_001',
        contractId: 'contract_001',
        productName: 'Electronics',
        pickupLocation: 'Los Angeles, CA',
        dropoffLocation: 'Seattle, WA',
        pickupContact: 'Warehouse A: +1-555-2001',
        dropoffContact: 'Distribution B: +1-555-2002',
        weight: 25000,
        price: 8500.00,
        status: 'in_transit',
        pickupDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Load(
        truckId: 'truck_002',
        contractId: 'contract_001',
        productName: 'Furniture',
        pickupLocation: 'Dallas, TX',
        dropoffLocation: 'Denver, CO',
        pickupContact: 'Factory X: +1-555-2003',
        dropoffContact: 'Store Y: +1-555-2004',
        weight: 18000,
        price: 6200.00,
        status: 'delivered',
        pickupDate: DateTime.now().subtract(const Duration(days: 7)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Load(
        truckId: 'truck_004',
        contractId: 'contract_002',
        productName: 'Construction Materials',
        pickupLocation: 'Miami, FL',
        dropoffLocation: 'Atlanta, GA',
        pickupContact: 'Site P: +1-555-2005',
        dropoffContact: 'Site Q: +1-555-2006',
        weight: 32000,
        price: 9800.00,
        status: 'pending',
        pickupDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Load(
        truckId: 'truck_001',
        contractId: 'contract_001',
        productName: 'Automotive Parts',
        pickupLocation: 'Detroit, MI',
        dropoffLocation: 'Indianapolis, IN',
        weight: 15000,
        price: 4500.00,
        status: 'pending',
        pickupDate: DateTime.now().add(const Duration(days: 3)),
      ),
    ];

    // Create routes
    _routes = [
      Route(
        contractId: 'contract_001',
        name: 'West Coast Highway',
        origin: 'Los Angeles, CA',
        destination: 'Seattle, WA',
        distance: 1135,
        estimatedTime: '18 hours',
      ),
      Route(
        contractId: 'contract_001',
        name: 'Southern Corridor',
        origin: 'Dallas, TX',
        destination: 'Denver, CO',
        distance: 780,
        estimatedTime: '12 hours',
      ),
      Route(
        contractId: 'contract_002',
        name: 'Southeast Route',
        origin: 'Miami, FL',
        destination: 'Atlanta, GA',
        distance: 665,
        estimatedTime: '10 hours',
      ),
    ];

    // Create activity logs
    _activityLogs = [
      ActivityLog(
        action: 'created',
        entityType: 'truck',
        entityId: 'truck_001',
        details: 'Added new truck TRK-2024-001',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityLog(
        action: 'updated',
        entityType: 'load',
        entityId: 'load_001',
        details: 'Load status changed to in_transit',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ActivityLog(
        action: 'created',
        entityType: 'fuel',
        entityId: 'fuel_001',
        details: 'Fuel purchase logged for TRK-2024-001',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      ActivityLog(
        action: 'updated',
        entityType: 'maintenance',
        entityId: 'maint_003',
        details: 'Maintenance status updated to in_progress',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      ActivityLog(
        action: 'created',
        entityType: 'driver',
        entityId: 'driver_004',
        details: 'New driver Emily Wilson onboarded',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      ActivityLog(
        action: 'completed',
        entityType: 'load',
        entityId: 'load_002',
        details: 'Load delivered successfully to Denver',
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
      ),
    ];

    notifyListeners();
  }

  // CRUD Operations
  void addContract(Contract contract) {
    _contracts.add(contract);
    _logActivity('created', 'contract', contract.id, 'New contract ${contract.name} created');
    notifyListeners();
  }

  void updateContract(Contract contract) {
    final index = _contracts.indexWhere((c) => c.id == contract.id);
    if (index != -1) {
      _contracts[index] = contract;
      _logActivity('updated', 'contract', contract.id, 'Contract ${contract.name} updated');
      notifyListeners();
    }
  }

  void deleteContract(String id) {
    _contracts.removeWhere((c) => c.id == id);
    _logActivity('deleted', 'contract', id, 'Contract deleted');
    notifyListeners();
  }

  void addTruck(Truck truck) {
    _trucks.add(truck);
    _logActivity('created', 'truck', truck.id, 'New truck ${truck.registrationNumber} added');
    notifyListeners();
  }

  void updateTruck(Truck truck) {
    final index = _trucks.indexWhere((t) => t.id == truck.id);
    if (index != -1) {
      _trucks[index] = truck;
      _logActivity('updated', 'truck', truck.id, 'Truck ${truck.registrationNumber} updated');
      notifyListeners();
    }
  }

  void deleteTruck(String id) {
    _trucks.removeWhere((t) => t.id == id);
    _logActivity('deleted', 'truck', id, 'Truck deleted');
    notifyListeners();
  }

  void addDriver(Driver driver) {
    _drivers.add(driver);
    _logActivity('created', 'driver', driver.id, 'New driver ${driver.name} added');
    notifyListeners();
  }

  void updateDriver(Driver driver) {
    final index = _drivers.indexWhere((d) => d.id == driver.id);
    if (index != -1) {
      _drivers[index] = driver;
      _logActivity('updated', 'driver', driver.id, 'Driver ${driver.name} updated');
      notifyListeners();
    }
  }

  void deleteDriver(String id) {
    _drivers.removeWhere((d) => d.id == id);
    _logActivity('deleted', 'driver', id, 'Driver deleted');
    notifyListeners();
  }

  void addFuelRecord(FuelRecord record) {
    _fuelRecords.add(record);
    _logActivity('created', 'fuel', record.id, 'Fuel purchase logged');
    notifyListeners();
  }

  void addMaintenanceRecord(MaintenanceRecord record) {
    _maintenanceRecords.add(record);
    _logActivity('created', 'maintenance', record.id, 'Maintenance record added');
    notifyListeners();
  }

  void addLoad(Load load) {
    _loads.add(load);
    _logActivity('created', 'load', load.id, 'New load ${load.productName} created');
    notifyListeners();
  }

  void updateLoad(Load load) {
    final index = _loads.indexWhere((l) => l.id == load.id);
    if (index != -1) {
      _loads[index] = load;
      _logActivity('updated', 'load', load.id, 'Load ${load.productName} updated');
      notifyListeners();
    }
  }

  void _logActivity(String action, String entityType, String entityId, String details) {
    _activityLogs.insert(0, ActivityLog(
      action: action,
      entityType: entityType,
      entityId: entityId,
      details: details,
    ));
  }

  Map<String, double> getWeeklyFuelConsumption() {
    final now = DateTime.now();
    final data = <String, double>{};

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final dayRecords = _fuelRecords.where((r) => 
        r.purchaseDate.year == date.year &&
        r.purchaseDate.month == date.month &&
        r.purchaseDate.day == date.day
      );
      data[dayName] = dayRecords.fold(0, (sum, r) => sum + r.amountLiters);
    }

    return data;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
