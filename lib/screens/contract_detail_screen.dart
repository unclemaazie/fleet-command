import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';

import 'package:flutter/material.dart';

class ContractDetailScreen extends StatelessWidget {
  const ContractDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contractId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, app, child) {
          final contract = contractId != null ? app.getContractById(contractId) : null;
          final trucks = contractId != null ? app.getTrucksByContract(contractId) : [];
          final drivers = contractId != null ? app.getDriversByContract(contractId) : [];
          final loads = contractId != null ? app.getLoadsByContract(contractId) : [];
          final routes = contractId != null ? app.getRoutesByContract(contractId) : [];

          if (contract == null) {
            return const Center(child: Text('Contract not found', style: TextStyle(color: Colors.white)));
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFA502), Color(0xFFFF4757)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.assignment,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            contract.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            contract.clientName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StatusBadge(status: contract.status),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Contract Details'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSpecRow('Client Email', contract.clientEmail),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Client Phone', contract.clientPhone),
                          if (contract.clientAddress != null) ...[
                            const Divider(color: Colors.white10, height: 16),
                            _buildSpecRow('Address', contract.clientAddress!),
                          ],
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Start Date', contract.startDate.toString().split(' ')[0]),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('End Date', contract.endDate.toString().split(' ')[0]),
                          if (contract.budget != null) ...[
                            const Divider(color: Colors.white10, height: 16),
                            _buildSpecRow('Budget', '\$${contract.budget!.toStringAsFixed(0)}'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Fleet (${trucks.length})'),
                    const SizedBox(height: 12),
                    ...trucks.map((truck) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4AA).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: Color(0xFF00D4AA),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truck.registrationNumber,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${truck.make} ${truck.model}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: truck.status, fontSize: 10),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Drivers (${drivers.length})'),
                    const SizedBox(height: 12),
                    ...drivers.map((driver) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B61FF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF7B61FF),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    driver.licenseType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: driver.status, fontSize: 10),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Routes (${routes.length})'),
                    const SizedBox(height: 12),
                    ...routes.map((route) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF74B9FF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.route,
                                color: Color(0xFF74B9FF),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    route.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${route.origin} → ${route.destination} (${route.distance.toStringAsFixed(0)} km)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Recent Loads'),
                    const SizedBox(height: 12),
                    ...loads.take(5).map((load) => Padding(
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
                                    load.productName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${load.pickupLocation} → ${load.dropoffLocation}',
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
                                  '\$${load.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7B61FF),
                                  ),
                                ),
                                StatusBadge(status: load.status, fontSize: 10),
                              ],
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
