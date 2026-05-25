import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../vendor/intl.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/animated_list_item.dart';

import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  int _currentIndex = 3;
  String _selectedStatus = 'all';

  void _onNavTap(int index) {
    if (index == 3) return;
    final routes = ['/dashboard', '/fleet', '/fuel', '/reports'];
    final routeIndex = index < 3 ? index : index - 1;
    Navigator.pushReplacementNamed(context, routes[routeIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final records = _selectedStatus == 'all'
              ? appProvider.maintenanceRecords
              : appProvider.maintenanceRecords
                  .where((r) => r.status == _selectedStatus)
                  .toList();

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
                              'Maintenance',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GlassIconButton(
                              onPressed: () => _showAddMaintenanceDialog(context, appProvider),
                              icon: Icons.add,
                              iconColor: const Color(0xFF00D4AA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatusFilter(),
                        const SizedBox(height: 16),
                        _buildMaintenanceStats(appProvider),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
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
                                              color: const Color(0xFF74B9FF).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.build,
                                              color: Color(0xFF74B9FF),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  record.serviceType,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  truck?.registrationNumber ?? 'Unknown Truck',
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
                                      StatusBadge(status: record.status),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(color: Colors.white10),
                                  const SizedBox(height: 8),
                                  Text(
                                    record.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem(
                                        Icons.business_outlined,
                                        record.serviceProvider,
                                        'Provider',
                                      ),
                                      _buildInfoItem(
                                        Icons.attach_money,
                                        '\$${record.cost.toStringAsFixed(2)}',
                                        'Cost',
                                      ),
                                      _buildInfoItem(
                                        Icons.calendar_today_outlined,
                                        DateFormat('MMM d').format(record.serviceDate),
                                        'Date',
                                      ),
                                    ],
                                  ),
                                  if (record.nextServiceDate != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFA502).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.event_repeat,
                                            size: 14,
                                            color: Color(0xFFFFA502),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Next: ${DateFormat('MMM d, yyyy').format(record.nextServiceDate!)}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFFFFA502),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget _buildStatusFilter() {
    final statuses = ['all', 'completed', 'in_progress', 'pending'];
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: statuses.map((s) => _buildFilterChip(s)).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String status) {
    final isSelected = _selectedStatus == status;
    final label = status == 'all' ? 'All' : status.replaceAll('_', ' ').toUpperCase();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = status),
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

  Widget _buildMaintenanceStats(AppProvider app) {
    final total = app.maintenanceRecords.length;
    final completed = app.maintenanceRecords.where((r) => r.status == 'completed').length;
    final inProgress = app.maintenanceRecords.where((r) => r.status == 'in_progress').length;
    final totalCost = app.maintenanceRecords.fold<double>(0, (sum, r) => sum + r.cost);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.build,
            total.toString(),
            'Total',
            const Color(0xFF74B9FF),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.check_circle,
            completed.toString(),
            'Done',
            const Color(0xFF00D4AA),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.pending,
            inProgress.toString(),
            'Active',
            const Color(0xFFFFA502),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.attach_money,
            '\$${totalCost.toStringAsFixed(0)}',
            'Spent',
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
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showAddMaintenanceDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Add Maintenance Record',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: const Text(
          'Feature coming soon',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF00D4AA))),
          ),
        ],
      ),
    );
  }
}
