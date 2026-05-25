import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/kpi_card.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/status_badge.dart';
import '../widgets/animated_list_item.dart';

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
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
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
            _GlassIconButton(
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

    final maxY = weeklyData.values.isEmpty
        ? 100.0
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
            child: weeklyData.isEmpty
                ? const Center(
                    child: Text(
                      'No fuel data available',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _BarChartPainter(
                      data: weeklyData.values.toList(),
                      labels: weeklyData.keys.toList(),
                      maxY: maxY,
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
      return '${timestamp.day} ${_monthName(timestamp.month)} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// Inline GlassIconButton since it was used but not imported/defined
class _GlassIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;

  const _GlassIconButton({
    required this.onPressed,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

// Custom bar chart painter to replace the broken chart library usage
class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double maxY;

  _BarChartPainter({
    required this.data,
    required this.labels,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final barWidth = (size.width / data.length) * 0.6;
    final spacing = (size.width / data.length) * 0.4;
    final chartHeight = size.height - 30;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxY) * chartHeight;
      final x = i * (barWidth + spacing) + spacing / 2;
      final y = size.height - barHeight - 20;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      final paint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

      canvas.drawRRect(rect, paint);

      // Draw label
      final textStyle = TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 10,
      );
      final textPainter = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, size.height - 14),
      );
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
