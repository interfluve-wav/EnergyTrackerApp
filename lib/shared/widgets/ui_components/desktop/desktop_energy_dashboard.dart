import 'package:flutter/material.dart';

// This file is a placeholder - the actual implementation is in desktop_home_screen.dart
// We'll move the dashboard logic here later for better organization

class DesktopEnergyDashboard extends StatelessWidget {
  const DesktopEnergyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Desktop Energy Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
