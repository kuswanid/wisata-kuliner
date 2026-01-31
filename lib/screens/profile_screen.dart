import 'package:flutter/material.dart';
import 'package:wisata_kuliner/screens/edit_profile_screen.dart';
import 'package:wisata_kuliner/screens/help_support_screen.dart';
import 'package:wisata_kuliner/screens/login_screen.dart';
import 'package:wisata_kuliner/screens/settings_screen.dart';
import 'package:wisata_kuliner/services/auth_service.dart';
import 'package:wisata_kuliner/services/user_service.dart';
import 'package:wisata_kuliner/models/user_model.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  UserModel? _user;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);
  final Color _textSubColor = const Color(0xFF897561);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _userService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: _user!.backgroundUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_user!.backgroundUrl),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              _primaryColor.withOpacityValue(0.4),
                              BlendMode.overlay,
                            ),
                          )
                        : DecorationImage(
                            image: const NetworkImage(
                              'https://img.freepik.com/free-photo/abstract-blur-food-truck_1339-3351.jpg',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              _primaryColor.withOpacityValue(0.8),
                              BlendMode.overlay,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _backgroundColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacityValue(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _user!.photoUrl.isNotEmpty
                          ? NetworkImage(_user!.photoUrl)
                          : null,
                      child: _user!.photoUrl.isEmpty
                          ? Text(
                              _user!.name.isNotEmpty
                                  ? _user!.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
              _user!.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textMainColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: _primaryColor),
                const SizedBox(width: 4),
                Text(
                  _user!.city.isNotEmpty ? _user!.city : 'Lokasi belum diatur',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSubColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profil',
                    onTap: () async {
                      if (_user != null) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(user: _user),
                          ),
                        );
                        if (result == true) {
                          _loadUser(); // Refresh user data if updated
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan & Dukungan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    color: Colors.red,
                    isDestructive: true,
                    onTap: () async {
                      await _authService.logoutUser();
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    bool isDestructive = false,
  }) {
    final itemColor = color ?? _textMainColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withOpacityValue(0.1)
                : Colors.orange.shade50,
          ),
          boxShadow: [
            BoxShadow(
              color: isDestructive
                  ? Colors.red.withOpacityValue(0.05)
                  : const Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacityValue(0.1)
                    : _primaryColor.withOpacityValue(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: itemColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: itemColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive
                  ? Colors.red.withOpacityValue(0.5)
                  : Colors.grey.withOpacityValue(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
