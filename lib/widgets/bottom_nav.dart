import 'package:flutter/material.dart';
import 'glass_card.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      borderRadius: 24,
      blurSigma: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 'Home', 0),
          _buildNavItem(Icons.local_shipping_outlined, Icons.local_shipping, 'Fleet', 1),
          _buildNavItem(Icons.local_gas_station_outlined, Icons.local_gas_station, 'Fuel', 2),
          _buildNavItem(Icons.build_outlined, Icons.build, 'Maint.', 3),
          _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Reports', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF00D4AA).withOpacity(0.15) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? const Color(0xFF00D4AA) : Colors.white.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF00D4AA) : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
