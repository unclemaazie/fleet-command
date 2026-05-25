import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';

import 'package:flutter/material.dart';

class DriverDetailScreen extends StatelessWidget {
  const DriverDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driverId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, app, child) {
          final driver = driverId != null ? app.getDriverById(driverId) : null;
          final truck = driver?.assignedTruckId != null ? app.getTruckById(driver!.assignedTruckId!) : null;

          if (driver == null) {
            return const Center(child: Text('Driver not found', style: TextStyle(color: Colors.white)));
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
                                colors: [Color(0xFF7B61FF), Color(0xFF00D4AA)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            driver.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            driver.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StatusBadge(status: driver.status),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('License Information'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSpecRow('License Number', driver.licenseNumber),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('License Type', driver.licenseType),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Expiry Date', driver.licenseExpiry.toString().split(' ')[0]),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSpecRow('Days Until Expiry', 
                            '${driver.licenseExpiry.difference(DateTime.now()).inDays} days'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Contact Information'),
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSpecRow('Phone', driver.phone),
                          if (driver.emergencyContact != null) ...[
                            const Divider(color: Colors.white10, height: 16),
                            _buildSpecRow('Emergency Contact', driver.emergencyContact!),
                          ],
                          if (driver.address != null) ...[
                            const Divider(color: Colors.white10, height: 16),
                            _buildSpecRow('Address', driver.address!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Assigned Vehicle'),
                    const SizedBox(height: 12),
                    if (truck != null)
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4AA).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: Color(0xFF00D4AA),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truck.registrationNumber,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${truck.make} ${truck.model}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: truck.status),
                          ],
                        ),
                      )
                    else
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No vehicle assigned',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
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
