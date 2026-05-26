import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../vendor/intl.dart';
import '../providers/app_provider.dart';
import '../models/fuel_record_model.dart';
import '../widgets/glass_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/animated_list_item.dart';

import 'package:flutter/material.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  int _currentIndex = 2;
  String _selectedTruckId = 'all';
  String _selectedPeriod = 'week';

  void _onNavTap(int index) {
    if (index == 2) return;
    final routes = ['/dashboard', '/fleet', '/maintenance', '/reports'];
    final routeIndex = index < 2 ? index : index - 1;
    Navigator.pushReplacementNamed(context, routes[routeIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final trucks = appProvider.trucks;
          final fuelRecords = _selectedTruckId == 'all'
              ? appProvider.fuelRecords
              : appProvider.getFuelRecordsByTruck(_selectedTruckId);

          return GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Fuel Management',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GlassIconButton(
                              onPressed: () => _showAddFuelDialog(context, appProvider),
                              icon: Icons.add,
                              iconColor: const Color(0xFF00D4AA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildFilters(trucks),
                        const SizedBox(height: 16),
                        _buildFuelStats(fuelRecords),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: fuelRecords.length,
                      itemBuilder: (context, index) {
                        final record = fuelRecords[index];
                        final truck = appProvider.getTruckById(record.truckId);

                        return AnimatedListItem(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFA502).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.local_gas_station,
                                              color: Color(0xFFFFA502),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                truck?.registrationNumber ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                record.stationName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\$${record.totalCost.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00D4AA),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(color: Colors.white10),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem(
                                        Icons.water_drop_outlined,
                                        '${record.amountLiters.toStringAsFixed(1)} L',
                                        'Amount',
                                      ),
                                      _buildInfoItem(
                                        Icons.attach_money,
                                        '\$${record.costPerLiter.toStringAsFixed(2)}/L',
                                        'Rate',
                                      ),
                                      _buildInfoItem(
                                        Icons.speed_outlined,
                                        '${record.odometerReading.toStringAsFixed(0)} km',
                                        'Odometer',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        record.stationLocation,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM d, yyyy HH:mm').format(record.purchaseDate),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildFilters(List trucks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All Trucks', 'all'),
              ...trucks.map((t) => _buildFilterChip(t.registrationNumber, t.id)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPeriodChip('Week', 'week'),
            const SizedBox(width: 8),
            _buildPeriodChip('Month', 'month'),
            const SizedBox(width: 8),
            _buildPeriodChip('Year', 'year'),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedTruckId == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTruckId = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D4AA).withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00D4AA).withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF00D4AA) : Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildFuelStats(List fuelRecords) {
    final totalLiters = fuelRecords.fold<double>(0, (sum, r) => sum + r.amountLiters);
    final totalCost = fuelRecords.fold<double>(0, (sum, r) => sum + r.totalCost);
    final avgCostPerLiter = fuelRecords.isEmpty
        ? 0
        : totalCost / totalLiters;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.water_drop,
            '${totalLiters.toStringAsFixed(0)} L',
            'Total Fuel',
            const Color(0xFFFFA502),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.attach_money,
            '\$${totalCost.toStringAsFixed(2)}',
            'Total Cost',
            const Color(0xFF00D4AA),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.price_check,
            '\$${avgCostPerLiter.toStringAsFixed(2)}',
            'Avg/Liter',
            const Color(0xFF7B61FF),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.4)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAddFuelDialog(BuildContext context, AppProvider provider) {
    final truckController = TextEditingController();
    final stationController = TextEditingController();
    final locationController = TextEditingController();
    final amountController = TextEditingController();
    final costController = TextEditingController();
    final odometerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Log Fuel Purchase',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stationController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Station Name',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.local_gas_station, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Location',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Amount (Liters)',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.water_drop_outlined, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Cost per Liter',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: odometerController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: 'Odometer Reading',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.speed_outlined, color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (stationController.text.isNotEmpty &&
                  amountController.text.isNotEmpty &&
                  costController.text.isNotEmpty) {
                final amount = double.tryParse(amountController.text) ?? 0;
                final cost = double.tryParse(costController.text) ?? 0;
                final odometer = double.tryParse(odometerController.text) ?? 0;

                provider.addFuelRecord(FuelRecord(
                  truckId: provider.trucks.first.id,
                  contractId: provider.trucks.first.contractId,
                  stationName: stationController.text,
                  stationLocation: locationController.text,
                  amountLiters: amount,
                  costPerLiter: cost,
                  totalCost: amount * cost,
                  odometerReading: odometer,
                  purchaseDate: DateTime.now(),
                ));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4AA),
              foregroundColor: const Color(0xFF0A0A0F),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
