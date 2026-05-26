import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../vendor/slidable.dart';
import '../providers/app_provider.dart';
import '../models/truck_model.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/animated_list_item.dart';

import 'package:flutter/material.dart';


class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  int _currentIndex = 1;
  String _selectedContractId = 'all';

  void _onNavTap(int index) {
    if (index == 1) return;
    final routes = ['/dashboard', '/fuel', '/maintenance', '/reports'];
    final routeIndex = index == 0 ? 0 : index - 1;
    Navigator.pushReplacementNamed(context, routes[routeIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final contracts = appProvider.contracts;
          final trucks = _selectedContractId == 'all'
              ? appProvider.trucks
              : appProvider.getTrucksByContract(_selectedContractId);

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
                              'Fleet',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GlassIconButton(
                              onPressed: () => _showAddTruckDialog(context, appProvider),
                              icon: Icons.add,
                              iconColor: const Color(0xFF00D4AA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildContractFilter(contracts),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: trucks.length,
                      itemBuilder: (context, index) {
                        final truck = trucks[index];
                        final driver = truck.driverId != null
                            ? appProvider.getDriverById(truck.driverId!)
                            : null;
                        final contract = appProvider.getContractById(truck.contractId);

                        return AnimatedListItem(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SimpleSlidable(
                              actions: [
                                
                                  SlidableAction(
                                    onPressed: () => _showEditTruckDialog(context, appProvider, truck),
                                    backgroundColor: const Color(0xFF7B61FF),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(16),
                                    ),
                                  ),
                                  SlidableAction(
                                    onPressed: () => _deleteTruck(context, appProvider, truck),
                                    backgroundColor: const Color(0xFFFF4757),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(16),
                                    ),
                                  ),
                                ],
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/truck-detail',
                                  arguments: truck.id,
                                ),
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
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFF00D4AA).withOpacity(0.3),
                                                      const Color(0xFF7B61FF).withOpacity(0.3),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.local_shipping,
                                                  color: Color(0xFF00D4AA),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    truck.registrationNumber,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${truck.make} ${truck.model} ${truck.year}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          StatusBadge(status: truck.status),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(color: Colors.white10),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoItem(
                                            Icons.person_outline,
                                            driver?.name ?? 'Unassigned',
                                            'Driver',
                                          ),
                                          _buildInfoItem(
                                            Icons.speed_outlined,
                                            '${truck.odometer.toStringAsFixed(0)} km',
                                            'Odometer',
                                          ),
                                          _buildInfoItem(
                                            Icons.assignment_outlined,
                                            contract?.name ?? 'Unknown',
                                            'Contract',
                                          ),
                                        ],
                                      ),
                                      if (truck.currentLoadId != null) ...[
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
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.local_shipping,
                                                size: 14,
                                                color: Color(0xFF00D4AA),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Active Load',
                                                style: TextStyle(
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

  Widget _buildContractFilter(List contracts) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', 'all'),
          ...contracts.map((c) => _buildFilterChip(c.name, c.id)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedContractId == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedContractId = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ),
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

  void _showAddTruckDialog(BuildContext context, AppProvider provider) {
    // Implementation for adding truck
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Add Truck', style: TextStyle(color: Colors.white)),
        content: const Text('Feature coming soon', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF00D4AA))),
          ),
        ],
      ),
    );
  }

  void _showEditTruckDialog(BuildContext context, AppProvider provider, Truck truck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Edit Truck', style: TextStyle(color: Colors.white)),
        content: const Text('Feature coming soon', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF00D4AA))),
          ),
        ],
      ),
    );
  }

  void _deleteTruck(BuildContext context, AppProvider provider, Truck truck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Delete Truck', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${truck.registrationNumber}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTruck(truck.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFFF4757))),
          ),
        ],
      ),
    );
  }
}
