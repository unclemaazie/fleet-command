import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/bottom_nav.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentIndex = 4;
  String _selectedReport = 'overview';

  void _onNavTap(int index) {
    if (index == 4) return;
    final routes = ['/dashboard', '/fleet', '/fuel', '/maintenance'];
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reports',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildReportTypeSelector(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildReportContent(appProvider),
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

  Widget _buildReportTypeSelector() {
    final reports = [
      {'id': 'overview', 'label': 'Overview', 'icon': Icons.dashboard},
      {'id': 'fuel', 'label': 'Fuel', 'icon': Icons.local_gas_station},
      {'id': 'maintenance', 'label': 'Maintenance', 'icon': Icons.build},
      {'id': 'loads', 'label': 'Loads', 'icon': Icons.inventory_2},
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          final isSelected = _selectedReport == report['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedReport = report['id'] as String),
              child: GlassCard(
                width: 100,
                padding: const EdgeInsets.all(12),
                backgroundColor: isSelected
                    ? const Color(0xFF00D4AA).withOpacity(0.2)
                    : null,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00D4AA).withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      report['icon'] as IconData,
                      color: isSelected
                          ? const Color(0xFF00D4AA)
                          : Colors.white.withOpacity(0.6),
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      report['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF00D4AA)
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportContent(AppProvider app) {
    switch (_selectedReport) {
      case 'fuel':
        return _buildFuelReport(app);
      case 'maintenance':
        return _buildMaintenanceReport(app);
      case 'loads':
        return _buildLoadsReport(app);
      default:
        return _buildOverviewReport(app);
    }
  }

  Widget _buildOverviewReport(AppProvider app) {
    return Column(
      children: [
        _buildSummaryCards(app),
        const SizedBox(height: 20),
        _buildExpenseBreakdown(app),
        const SizedBox(height: 20),
        _buildContractPerformance(app),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSummaryCards(AppProvider app) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildSummaryCard(
          'Total Revenue',
          '\$${app.totalLoadRevenue.toStringAsFixed(0)}',
          Icons.attach_money,
          const Color(0xFF00D4AA),
        ),
        _buildSummaryCard(
          'Total Expenses',
          '\$${(app.totalFuelCost + app.totalMaintenanceCost).toStringAsFixed(0)}',
          Icons.money_off,
          const Color(0xFFFF4757),
        ),
        _buildSummaryCard(
          'Net Profit',
          '\$${(app.totalLoadRevenue - app.totalFuelCost - app.totalMaintenanceCost).toStringAsFixed(0)}',
          Icons.trending_up,
          const Color(0xFF7B61FF),
        ),
        _buildSummaryCard(
          'Active Trucks',
          '${app.activeTrucks}/${app.totalTrucks}',
          Icons.local_shipping,
          const Color(0xFF74B9FF),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown(AppProvider app) {
    final fuelCost = app.totalFuelCost;
    final maintenanceCost = app.totalMaintenanceCost;
    final total = fuelCost + maintenanceCost;

    if (total == 0) return const SizedBox.shrink();

    final fuelPercentage = (fuelCost / total) * 100;
    final maintenancePercentage = (maintenanceCost / total) * 100;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPieSlice(
                  value: fuelCost,
                  title: '${fuelPercentage.toStringAsFixed(1)}%',
                  color: const Color(0xFFFFA502),
                ),
                const SizedBox(width: 20),
                _buildPieSlice(
                  value: maintenanceCost,
                  title: '${maintenancePercentage.toStringAsFixed(1)}%',
                  color: const Color(0xFF74B9FF),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Fuel', const Color(0xFFFFA502), '\$${fuelCost.toStringAsFixed(0)}'),
              const SizedBox(width: 24),
              _buildLegendItem('Maintenance', const Color(0xFF74B9FF), '\$${maintenanceCost.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieSlice({
    required double value,
    required String title,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContractPerformance(AppProvider app) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contract Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...app.contracts.map((contract) {
            final contractTrucks = app.getTrucksByContract(contract.id).length;
            final contractLoads = app.getLoadsByContract(contract.id);
            final contractRevenue = contractLoads
                .where((l) => l.status == 'delivered')
                .fold<double>(0, (sum, l) => sum + l.price);
            final contractFuel = app.fuelRecords
                .where((r) => r.contractId == contract.id)
                .fold<double>(0, (sum, r) => sum + r.totalCost);
            final contractMaint = app.maintenanceRecords
                .where((r) => r.contractId == contract.id)
                .fold<double>(0, (sum, r) => sum + r.cost);
            final profit = contractRevenue - contractFuel - contractMaint;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contract.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: profit >= 0
                              ? const Color(0xFF00D4AA).withOpacity(0.15)
                              : const Color(0xFFFF4757).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          profit >= 0 ? 'Profitable' : 'Loss',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: profit >= 0 ? const Color(0xFF00D4AA) : const Color(0xFFFF4757),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildContractStat('Trucks', contractTrucks.toString()),
                      _buildContractStat('Loads', contractLoads.length.toString()),
                      _buildContractStat('Revenue', '\$${contractRevenue.toStringAsFixed(0)}'),
                      _buildContractStat('Profit', '\$${profit.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContractStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFuelReport(AppProvider app) {
    final weeklyData = app.getWeeklyFuelConsumption();
    final entries = weeklyData.entries.toList();

    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fuel Consumption Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: entries.isEmpty
                    ? const Center(
                        child: Text(
                          'No fuel data available',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _LineChartPainter(
                          data: entries.map((e) => e.value).toList(),
                          labels: entries.map((e) => e.key).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildFuelDetailsTable(app),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildFuelDetailsTable(AppProvider app) {
    final records = app.fuelRecords.take(10).toList();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Fuel Records',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...records.map((record) {
            final truck = app.getTruckById(record.truckId);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      truck?.registrationNumber ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${record.amountLiters.toStringAsFixed(0)}L',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '\$${record.totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00D4AA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReport(AppProvider app) {
    final records = app.maintenanceRecords;
    final totalCost = records.fold<double>(0, (sum, r) => sum + r.cost);

    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Maintenance Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildMaintenanceStatRow('Total Records', records.length.toString(), const Color(0xFF74B9FF)),
              const SizedBox(height: 8),
              _buildMaintenanceStatRow('Total Cost', '\$${totalCost.toStringAsFixed(2)}', const Color(0xFFFF4757)),
              const SizedBox(height: 8),
              _buildMaintenanceStatRow(
                'Completed',
                records.where((r) => r.status == 'completed').length.toString(),
                const Color(0xFF00D4AA),
              ),
              const SizedBox(height: 8),
              _buildMaintenanceStatRow(
                'In Progress',
                records.where((r) => r.status == 'in_progress').length.toString(),
                const Color(0xFFFFA502),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Maintenance by Truck',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...app.trucks.map((truck) {
                final truckRecords = records.where((r) => r.truckId == truck.id);
                final truckCost = truckRecords.fold<double>(0, (sum, r) => sum + r.cost);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        truck.registrationNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${truckRecords.length} records',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '\$${truckCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF74B9FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildMaintenanceStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadsReport(AppProvider app) {
    final loads = app.loads;
    final delivered = loads.where((l) => l.status == 'delivered').toList();
    final totalRevenue = delivered.fold<double>(0, (sum, l) => sum + l.price);
    final totalWeight = loads.fold<double>(0, (sum, l) => sum + l.weight);

    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Load Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildLoadStatRow('Total Loads', loads.length.toString(), const Color(0xFF7B61FF)),
              const SizedBox(height: 8),
              _buildLoadStatRow('Delivered', delivered.length.toString(), const Color(0xFF00D4AA)),
              const SizedBox(height: 8),
              _buildLoadStatRow('Total Revenue', '\$${totalRevenue.toStringAsFixed(2)}', const Color(0xFFFFA502)),
              const SizedBox(height: 8),
              _buildLoadStatRow('Total Weight', '${totalWeight.toStringAsFixed(0)} kg', const Color(0xFF74B9FF)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Load Status Distribution',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...['pending', 'in_transit', 'delivered'].map((status) {
                final count = loads.where((l) => l.status == status).length;
                final percentage = loads.isEmpty ? 0 : (count / loads.length) * 100;
                final color = status == 'pending'
                    ? const Color(0xFFFFA502)
                    : status == 'in_transit'
                        ? const Color(0xFF74B9FF)
                        : const Color(0xFF00D4AA);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '$count (${percentage.toStringAsFixed(0)}%)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: loads.isEmpty ? 0 : count / loads.length,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildLoadStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;

  _LineChartPainter({required this.data, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF00D4AA)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00D4AA).withOpacity(0.3),
          const Color(0xFF00D4AA).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue == minValue ? 1 : maxValue - minValue;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minValue) / range) * (size.height - 40) - 20;
      points.add(Offset(x, y));
    }

    // Draw fill
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = const Color(0xFF00D4AA)
      ..style = PaintingStyle.fill;

    final dotStrokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotStrokePaint);
    }

    // Draw labels
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 10,
    );
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < labels.length && i < data.length; i++) {
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();
      final x = (i / (data.length - 1)) * size.width - textPainter.width / 2;
      textPainter.paint(canvas, Offset(x, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
