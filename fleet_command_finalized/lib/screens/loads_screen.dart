import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../vendor/intl.dart';
import '../providers/app_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/animated_list_item.dart';

import 'package:flutter/material.dart';

class LoadsScreen extends StatefulWidget {
  const LoadsScreen({super.key});

  @override
  State<LoadsScreen> createState() => _LoadsScreenState();
}

class _LoadsScreenState extends State<LoadsScreen> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final loads = _selectedStatus == 'all'
              ? appProvider.loads
              : appProvider.loads.where((l) => l.status == _selectedStatus).toList();

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
                              'Product Loads',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GlassIconButton(
                              onPressed: () => _showAddLoadDialog(context, appProvider),
                              icon: Icons.add,
                              iconColor: const Color(0xFF00D4AA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatusFilter(),
                        const SizedBox(height: 16),
                        _buildLoadStats(appProvider),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: loads.length,
                      itemBuilder: (context, index) {
                        final load = loads[index];
                        final truck = appProvider.getTruckById(load.truckId);

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
                                              color: const Color(0xFF7B61FF).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.inventory_2,
                                              color: Color(0xFF7B61FF),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  load.productName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  truck?.registrationNumber ?? 'Unassigned',
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
                                      StatusBadge(status: load.status),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(color: Colors.white10),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildLocationItem(
                                          Icons.location_on_outlined,
                                          load.pickupLocation,
                                          'Pickup',
                                          const Color(0xFF00D4AA),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white30,
                                        size: 20,
                                      ),
                                      Expanded(
                                        child: _buildLocationItem(
                                          Icons.location_on,
                                          load.dropoffLocation,
                                          'Dropoff',
                                          const Color(0xFFFF4757),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem(
                                        Icons.scale_outlined,
                                        '${load.weight.toStringAsFixed(0)} kg',
                                        'Weight',
                                      ),
                                      _buildInfoItem(
                                        Icons.attach_money,
                                        '\$${load.price.toStringAsFixed(2)}',
                                        'Price',
                                      ),
                                      _buildInfoItem(
                                        Icons.calendar_today_outlined,
                                        DateFormat('MMM d').format(load.pickupDate),
                                        'Pickup',
                                      ),
                                    ],
                                  ),
                                  if (load.deliveryDate != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00D4AA).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            size: 14,
                                            color: Color(0xFF00D4AA),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Delivered: ${DateFormat('MMM d, yyyy').format(load.deliveryDate!)}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF00D4AA),
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
    );
  }

  Widget _buildStatusFilter() {
    final statuses = ['all', 'pending', 'in_transit', 'delivered'];
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

  Widget _buildLoadStats(AppProvider app) {
    final total = app.loads.length;
    final pending = app.loads.where((l) => l.status == 'pending').length;
    final inTransit = app.loads.where((l) => l.status == 'in_transit').length;
    final delivered = app.loads.where((l) => l.status == 'delivered').length;
    final revenue = app.loads.where((l) => l.status == 'delivered').fold<double>(0, (sum, l) => sum + l.price);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.inventory_2,
            total.toString(),
            'Total',
            const Color(0xFF7B61FF),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.pending,
            pending.toString(),
            'Pending',
            const Color(0xFFFFA502),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.local_shipping,
            inTransit.toString(),
            'Transit',
            const Color(0xFF74B9FF),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _buildStatItem(
            Icons.attach_money,
            '\$${revenue.toStringAsFixed(0)}',
            'Revenue',
            const Color(0xFF00D4AA),
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

  Widget _buildLocationItem(IconData icon, String location, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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

  void _showAddLoadDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Add Load',
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
