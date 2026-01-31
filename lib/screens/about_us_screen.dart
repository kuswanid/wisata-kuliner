import 'package:flutter/material.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF6B00);
    const Color backgroundColor = Color(0xFFFFF8F2);
    const Color textMainColor = Color(0xFF2D2420);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tentang Kami',
          style: TextStyle(color: textMainColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacityValue(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacityValue(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Wisata Kuliner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textMainColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jelajahi Citarasa Nusantara',
                    style: TextStyle(
                      fontSize: 14,
                      color: textMainColor.withOpacityValue(0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Aplikasi ini dibuat untuk membantu Anda menemukan kuliner terbaik di sekitar Anda. Kami berdedikasi untuk mempromosikan kekayaan kuliner lokal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.5, color: Color(0xFF897561)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Tim Kami',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textMainColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildMemberCard(context, 'Rian', 'Lead Developer'),
            const SizedBox(height: 12),
            _buildMemberCard(context, 'Anggota 2', 'UI/UX Designer'),
            const SizedBox(height: 12),
            _buildMemberCard(context, 'Anggota 3', 'Backend Developer'),
            const SizedBox(height: 12),
            _buildMemberCard(context, 'Anggota 4', 'Quality Assurance'),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, String name, String role) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade50),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacityValue(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Color(0xFFFF6B00)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2420),
                ),
              ),
              Text(
                role,
                style: const TextStyle(fontSize: 12, color: Color(0xFF897561)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
