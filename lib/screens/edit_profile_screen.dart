import 'package:flutter/material.dart';
import 'package:wisata_kuliner/models/user_model.dart';
import 'package:wisata_kuliner/services/user_service.dart';
import 'package:wisata_kuliner/utils/image_utils.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;

  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _photoUrlController;
  late TextEditingController _backgroundUrlController;

  bool _isLoading = false;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _cityController = TextEditingController(text: widget.user?.city ?? '');
    _photoUrlController = TextEditingController(text: widget.user?.photoUrl ?? '');
    _backgroundUrlController = TextEditingController(text: widget.user?.backgroundUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _photoUrlController.dispose();
    _backgroundUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final processedPhotoUrl = ImageUtils.convertDriveLink(_photoUrlController.text);
      final processedBackgroundUrl = ImageUtils.convertDriveLink(_backgroundUrlController.text);

      await _userService.updateUserProfile(
        uid: widget.user!.id,
        name: _nameController.text,
        city: _cityController.text,
        photoUrl: processedPhotoUrl,
        backgroundUrl: processedBackgroundUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Profil berhasil diperbarui'), backgroundColor: _primaryColor),
        );
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.orange.shade100),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.orange.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Edit Profil', style: TextStyle(color: _textMainColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo Upload Placeholder
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _primaryColor, width: 2),
                      ),
                      child: Icon(Icons.person, size: 60, color: Colors.grey[300]),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: _primaryColor,
                        radius: 18,
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Nama Lengkap'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _cityController,
                decoration: _buildInputDecoration('Kota Domisili'),
                validator: (value) => value!.isEmpty ? 'Kota tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Placeholder for Profile Photo URL if we really want to simulate it
              TextFormField(
                controller: _photoUrlController,
                decoration: _buildInputDecoration('URL Foto Profil'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _backgroundUrlController,
                decoration: _buildInputDecoration('URL Background'),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
