import 'package:flutter/material.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B00);
    const Color backgroundColor = Color(0xFFFFF8F2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Bantuan & Dukungan',
          style: TextStyle(
            color: Color(0xFF2D2420),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFAQItem(
              'Bagaimana cara memesan makanan?',
              'Saat ini fitur pemesanan belum tersedia. Aplikasi ini berfungsi sebagai katalog wisata kuliner untuk membantu Anda menemukan makanan terbaik di sekitar.',
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              'Bagaimana cara mengubah profil saya?',
              'Anda dapat mengubah profil dengan masuk ke menu Profil dan menekan tombol Edit Profil.',
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              'Apakah saya bisa mendaftarkan restoran saya?',
              'Ya, Anda bisa mendaftar sebagai Owner saat registrasi akun baru untuk mengelola restoran Anda.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Hubungi Kami',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacityValue(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email_outlined,
                    'Email',
                    'support@wisatakuliner.id',
                  ),
                  const Divider(height: 30),
                  _buildContactItem(
                    Icons.phone_outlined,
                    'WhatsApp',
                    '+62 812 3456 7890',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade50),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2420),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(color: Color(0xFF897561)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B00).withOpacityValue(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFFF6B00)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2D2420),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
