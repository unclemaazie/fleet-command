import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';

import 'package:flutter/material.dart';

class TruckDetailScreen extends StatelessWidget {
  const TruckDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final truckId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, app, child) {
          final truck = truckId != null ? app.getTruckById(truckId) : null;
          final driver = truck?.driverId != null ? app.getDriverById(truck!.driverId!) : null;
          final fuelRecords = truckId != null ? app.getFuelRecordsByTruck(truckId) : [];
          final maintenanceRecords = truckId != null ? app.getMaintenanceRecordsByTruck(truckId) : [];
          final loads = truckId != null ? app.getLoadsByTruck(truckId) : [];

          if (truck == null) {
            return const Center(child: Text('Truck not found', style: TextStyle(color: Colors.white)));
          }

          return GradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GlassIconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icons.arrow_back,
                          iconColor: Colors.white70,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF00D4AA).withOpacity(0.3),
                                  const Color(0xFF7B61FF).withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.local_shipping,
                              size: 40,
                              color: Color(0xFF00D4AA),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            truck.registrationNumber,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${truck.make} ${truck.model} ${truck.year}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StatusBadge(status: truck.status),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Specifications'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSpecRow('Odometer', '${truck.odometer.toStringAsFixed(0)} km'),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Driver', driver?.name ?? 'Unassigned'),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Contract', app.getContractById(truck.contractId)?.name ?? 'Unknown'),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Current Load', truck.currentLoadId != null ? 'Active' : 'None'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Fuel History'),
                    const SizedBox(height: 12),
                    ...fuelRecords.take(5).map((record) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.stationName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${record.amountLiters.toStringAsFixed(1)} L',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${record.totalCost.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00D4AA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Maintenance History'),
                    const SizedBox(height: 12),
                    ...maintenanceRecords.map((record) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.serviceType,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    record.serviceProvider,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${record.cost.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF74B9FF),
                                  ),
                                ),
                                StatusBadge(status: record.status, fontSize: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Load History'),
                    const SizedBox(height: 12),
                    ...loads.map((load) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  load.productName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                StatusBadge(status: load.status, fontSize: 10),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${load.pickupLocation} → ${load.dropoffLocation}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${load.price.toStringAsFixed(2)} | ${load.weight.toStringAsFixed(0)} kg',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7B61FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
