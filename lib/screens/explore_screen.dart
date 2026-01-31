import 'package:flutter/material.dart';
import 'package:wisata_kuliner/widgets/app_drawer.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Text('Selamat datang.')]),
      drawer: AppDrawer(),
    );
  }
}
