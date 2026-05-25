# Fiki'sFleetCommand - Zero-Dependency Flutter Fleet Management App

A comprehensive Flutter-based Fleet Management mobile app with **NO external dependencies**.
All third-party packages (provider, fl_chart, flutter_slidable, flutter_animate, uuid, intl) 
have been replaced with custom lightweight implementations in `lib/vendor/`.

## Features

### Core Functionality
- **Contract-based Organization**: Each contract has its own fleet, drivers, routes, pick-up/drop-off locations, and expense tracking
- **Truck Management**: Complete profiles with registration, make, model, odometer, status, and driver assignment
- **Driver Management**: License tracking, contact info, emergency contacts, and vehicle assignment
- **Fuel Logging**: Per-truck fuel purchases with station, amount, cost, and date tracking tied to consumption charts
- **Load Tracking**: Product loads with weights, pricing, pickup/dropoff locations, and status tracking
- **Maintenance Records**: Service history with provider, cost, parts replaced, and next service dates
- **Reports**: Individual and combined reports across fuel, maintenance, and product expenses

### UI/UX
- **Dark Theme with Glassmorphism**: Frosted glass effects throughout the app
- **6-Metric KPI Grid**: Dashboard with real-time fleet metrics
- **Weekly Fuel Chart**: Custom bar chart visualization of fuel consumption
- **Activity Feed**: Real-time log of all operations with staggered animations
- **Swipe Actions**: Edit and delete trucks via swipe gestures (custom implementation)
- **Status Badges**: Color-coded status indicators

## Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| Fleet Manager | manager@fikisfleetcommand.io | Fleet@2024 |
| Driver | driver@fikisfleetcommand.io | Driver@2024 |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── vendor/                   # Custom dependency replacements
│   ├── provider.dart         # State management (replaces package:provider)
│   ├── chart.dart            # Charts (replaces fl_chart)
│   ├── slidable.dart         # Swipe actions (replaces flutter_slidable)
│   ├── animate.dart          # Animations (replaces flutter_animate)
│   ├── uuid.dart             # UUID generation (replaces package:uuid)
│   ├── intl.dart             # Date formatting (replaces package:intl)
│   └── vendor.dart           # Export barrel file
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # UI screens (12 screens)
└── widgets/                  # Reusable components
```

## Building the APK

### Prerequisites
- Flutter SDK (>=3.0.0) - ONLY dependency needed!
- Android Studio with SDK Platform 34
- JDK 17

### Steps

```bash
# 1. Extract the project
unzip fikis_fleet_command.zip
cd fikis_fleet_command

# 2. Configure Android SDK paths in android/local.properties:
# flutter.sdk=/path/to/flutter
# sdk.dir=/path/to/android/sdk

# 3. Build release APK (NO flutter pub get needed!)
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build Variants
| Command | Output |
|---------|--------|
| `flutter build apk` | Debug APK |
| `flutter build apk --release` | Release APK (optimized) |
| `flutter build appbundle --release` | Play Store bundle (.aab) |

## Why Zero Dependencies?

This project includes custom lightweight implementations of commonly used packages:
- **provider**: 150 lines vs 3,000+ lines - covers ChangeNotifierProvider, Consumer, MultiProvider
- **fl_chart**: 300 lines vs 15,000+ lines - covers BarChart, LineChart, PieChart
- **flutter_slidable**: 150 lines vs 2,000+ lines - covers swipe actions
- **flutter_animate**: 80 lines vs 5,000+ lines - covers fade/slide animations
- **uuid**: 30 lines vs 500+ lines - covers UUID v4 generation
- **intl**: 50 lines vs 10,000+ lines - covers basic date formatting

This makes the app:
- Faster to build (no dependency resolution)
- Smaller APK size
- No supply chain risks
- Easier to audit and maintain
