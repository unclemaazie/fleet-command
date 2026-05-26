import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/fleet_screen.dart';
import 'screens/fuel_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/loads_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/truck_detail_screen.dart';
import 'screens/driver_detail_screen.dart';
import 'screens/contract_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FleetCommandApp());
}

class FleetCommandApp extends StatelessWidget {
  const FleetCommandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: "Fiki'sFleetCommand",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0A0F),
          primaryColor: const Color(0xFF00D4AA),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00D4AA),
            secondary: Color(0xFF7B61FF),
            surface: Color(0xFF1A1A2E),
            background: Color(0xFF0A0A0F),
            error: Color(0xFFFF4757),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
            labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00D4AA),
            ),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1A1A2E).withOpacity(0.8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1A1A2E).withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00D4AA), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D4AA),
              foregroundColor: const Color(0xFF0A0A0F),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/fleet': (context) => const FleetScreen(),
          '/fuel': (context) => const FuelScreen(),
          '/maintenance': (context) => const MaintenanceScreen(),
          '/loads': (context) => const LoadsScreen(),
          '/reports': (context) => const ReportsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/truck-detail': (context) => const TruckDetailScreen(),
          '/driver-detail': (context) => const DriverDetailScreen(),
          '/contract-detail': (context) => const ContractDetailScreen(),
        },
      ),
    );
  }
}
