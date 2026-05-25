import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../vendor/chart.dart';
import '../vendor/intl.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/kpi_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/status_badge.dart';
import '../widgets/animated_list_item.dart';

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).initializeDemoData();
    });
  }

  void _onNavTap(int index) {
    if (index == 0) return;
    final routes = ['/fleet', '/fuel', '/maintenance', '/reports'];
    Navigator.pushNamed(context, routes[index - 1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AppProvider, AuthProvider>(
        builder: (context, appProvider, authProvider, child) {
          return GradientBackground(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(authProvider),
                          const SizedBox(height: 24),
                          _buildKpiGrid(appProvider),
                          const SizedBox(height: 24),
                          _buildFuelChart(appProvider),
                          const SizedBox(height: 24),
                          _buildAlertSection(appProvider),
                          const SizedBox(height: 24),
                          _buildActivityFeed(appProvider),
                          const SizedBox(height: 80),
                        ],
                      ),
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

  Widget _buildHeader(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${auth.currentUser?.name ?? 'User'}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GlassIconButton(
              onPressed: () {},
              icon: Icons.notifications_outlined,
              iconColor: Colors.white70,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiGrid(AppProvider app) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        KpiCard(
          title: 'Total Trucks',
          value: app.totalTrucks.toString(),
          icon: Icons.local_shipping,
          color: const Color(0xFF00D4AA),
          subtitle: '${app.activeTrucks} active',
          trend: 12.5,
        ),
        KpiCard(
          title: 'Active Drivers',
          value: app.totalDrivers.toString(),
          icon: Icons.people,
          color: const Color(0xFF7B61FF),
          subtitle: 'On duty now',
          trend: 8.3,
        ),
        KpiCard(
          title: 'Fuel Cost',
          value: '\$${app.totalFuelCost.toStringAsFixed(0)}',
          icon: Icons.local_gas_station,
          color: const Color(0xFFFFA502),
          subtitle: 'This month',
          trend: -5.2,
        ),
        KpiCard(
          title: 'Pending Loads',
          value: app.pendingLoads.toString(),
          icon: Icons.inventory_2,
          color: const Color(0xFFFF4757),
          subtitle: '${app.completedLoads} delivered',
          trend: 15.0,
        ),
        KpiCard(
          title: 'Contracts',
          value: app.activeContracts.toString(),
          icon: Icons.assignment,
          color: const Color(0xFF2ED573),
          subtitle: 'Active now',
        ),
        KpiCard(
          title: 'Maintenance',
          value: '\$${app.totalMaintenanceCost.toStringAsFixed(0)}',
          icon: Icons.build,
          color: const Color(0xFF74B9FF),
          subtitle: 'Total spent',
        ),
      ],
    );
  }

  Widget _buildFuelChart(AppProvider app) {
    final weeklyData = app.getWeeklyFuelConsumption();
    final barData = weeklyData.entries.map((e) => BarData(label: e.key, value: e.value)).toList();

    final maxY = weeklyData.values.isEmpty 
        ? 100 
        : weeklyData.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Fuel Consumption',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Liters',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF00D4AA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SimpleSimpleBarChart(
              data: weeklyData.entries.map((e) => BarData(label: e.key, value: e.value)).toList(),
              maxY: maxY,
            ),
                    },
                  ),
                ),
                titlesData: (
                  show: true,
                  bottomTitles: (
                    sideTitles: (
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = weeklyData.keys.toList();
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: (
                    sideTitles: (
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const (sideTitles: (showTitles: false)),
                  rightTitles: const (sideTitles: (showTitles: false)),
                ),
                gridData: (
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 5,
                      color: Colors.white.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: (show: false),
                barGroups: spots.asMap().entries.map((entry) {
                  return Simple(
                    x: entry.key,
                    barRods: [
                      Simple(
                        toY: entry.value.y,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundSimple(
                          show: true,
                          toY: maxY,
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertSection(AppProvider app) {
    final maintenanceAlerts = app.maintenanceRecords
        .where((m) => m.status == 'in_progress' || m.status == 'pending')
        .toList();

    if (maintenanceAlerts.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4757).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFF4757),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Alerts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4757).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${maintenanceAlerts.length} active',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFFF4757),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...maintenanceAlerts.asMap().entries.map((entry) {
            final truck = app.getTruckById(entry.value.truckId);
            return AnimatedListItem(
              index: entry.key,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4757).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFFF4757).withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.build_circle_outlined,
                      color: Color(0xFFFF4757),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value.serviceType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            truck?.registrationNumber ?? 'Unknown Truck',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: entry.value.status),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityFeed(AppProvider app) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF00D4AA),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...app.activityLogs.take(6).toList().asMap().entries.map((entry) {
            final log = entry.value;
            return AnimatedListItem(
              index: entry.key,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getActivityColor(log.action).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getActivityIcon(log.action),
                        color: _getActivityColor(log.action),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.details,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(log.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getActivityColor(String action) {
    switch (action) {
      case 'created':
        return const Color(0xFF00D4AA);
      case 'updated':
        return const Color(0xFF7B61FF);
      case 'deleted':
        return const Color(0xFFFF4757);
      case 'completed':
        return const Color(0xFF2ED573);
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action) {
      case 'created':
        return Icons.add_circle_outline;
      case 'updated':
        return Icons.edit_outlined;
      case 'deleted':
        return Icons.delete_outline;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
