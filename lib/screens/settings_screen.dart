import 'package:flutter/material.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B00);
    const Color backgroundColor = Color(0xFFFFF8F2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF2D2420),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsSection('Umum', [
            _buildSettingsTile(Icons.language, 'Bahasa', 'Indonesia'),
            _buildSettingsTile(
              Icons.notifications_outlined,
              'Notifikasi',
              'Aktif',
            ),
            _buildSettingsTile(
              Icons.dark_mode_outlined,
              'Tema Gelap',
              'Nonaktif',
            ),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Keamanan', [
            _buildSettingsTile(Icons.lock_outline, 'Ganti Password', ''),
            _buildSettingsTile(
              Icons.privacy_tip_outlined,
              'Privasi & Keamanan',
              '',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2420),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityValue(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B00).withOpacityValue(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFFF6B00), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: () {
        // TODO: Implement settings logic
      },
    );
  }
}
