import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../vendor/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.currentUser;
          return GradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GlassIconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icons.arrow_back,
                          iconColor: Colors.white70,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4AA), Color(0xFF7B61FF)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4AA).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4AA).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (user?.role ?? 'user').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00D4AA),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileItem(Icons.email_outlined, 'Email', user?.email ?? ''),
                          const Divider(color: Colors.white10, height: 24),
                          _buildProfileItem(Icons.badge_outlined, 'User ID', user?.id ?? ''),
                          const Divider(color: Colors.white10, height: 24),
                          _buildProfileItem(
                            Icons.calendar_today_outlined,
                            'Member Since',
                            user?.createdAt.toString().split(' ')[0] ?? '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingItem(
                            Icons.notifications_outlined,
                            'Notifications',
                            'Enabled',
                          ),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSettingItem(
                            Icons.dark_mode_outlined,
                            'Dark Mode',
                            'Always On',
                          ),
                          const Divider(color: Colors.white10, height: 16),
                          _buildSettingItem(
                            Icons.cloud_outlined,
                            'Cloud Sync',
                            'Active',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          auth.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4757).withOpacity(0.2),
                          foregroundColor: const Color(0xFFFF4757),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFFF4757)),
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

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF00D4AA),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 20),
      ],
    );
  }
}
