import 'package:flutter/material.dart';
import 'package:wisata_kuliner/widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: AppDrawer(),
    );
  }
}
