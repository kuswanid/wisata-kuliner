import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisata_kuliner/models/menu_model.dart';
import 'package:wisata_kuliner/services/menu_service.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class AddEditMenuScreen extends StatefulWidget {
  final MenuModel? menu;

  const AddEditMenuScreen({super.key, this.menu});

  @override
  State<AddEditMenuScreen> createState() => _AddEditMenuScreenState();
}

class _AddEditMenuScreenState extends State<AddEditMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final MenuService _menuService = MenuService();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late TextEditingController _regionController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menu?.name ?? '');
    _priceController = TextEditingController(
      text: widget.menu != null
          ? NumberFormat.currency(
              locale: 'id_ID',
              symbol: '',
              decimalDigits: 0,
            ).format(widget.menu!.price).trim()
          : '',
    );
    _locationController = TextEditingController(
      text: widget.menu?.location ?? '',
    );
    _regionController = TextEditingController(text: widget.menu?.region ?? '');
    _categoryController = TextEditingController(
      text: widget.menu?.category ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.menu?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.menu?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _regionController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String _convertDriveLink(String url) {
    if (url.contains('drive.google.com') && url.contains('/file/d/')) {
      final RegExp regExp = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        return 'https://drive.google.com/uc?export=view&id=$id';
      }
    }
    return url;
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final menu = MenuModel(
        id: widget.menu?.id ?? '',
        name: _nameController.text,
        imageUrl: _convertDriveLink(_imageUrlController.text),
        price: double.tryParse(_priceController.text.replaceAll('.', '')) ?? 0,
        location: _locationController.text,
        region: _regionController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
      );

      if (widget.menu == null) {
        await _menuService.addMenu(menu);
      } else {
        await _menuService.updateMenu(menu);
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Menu berhasil disimpan'),
            backgroundColor: _primaryColor,
          ),
        );
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

  InputDecoration _buildInputDecoration(
    String label, {
    String? hint,
    String? helper,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      labelStyle: TextStyle(color: _textMainColor.withOpacityValue(0.7)),
      floatingLabelStyle: TextStyle(color: _primaryColor),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.menu == null ? 'Tambah Menu' : 'Edit Menu',
          style: TextStyle(color: _textMainColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: _primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview Area
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange.shade100),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacityValue(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ValueListenableBuilder(
                  valueListenable: _imageUrlController,
                  builder: (context, value, child) {
                    final processedUrl = _convertDriveLink(value.text);
                    if (processedUrl.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          processedUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Gagal memuat gambar',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                            color: _primaryColor.withOpacityValue(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Preview gambar',
                            style: TextStyle(
                              color: _textMainColor.withOpacityValue(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _imageUrlController,
                decoration: _buildInputDecoration(
                  'URL Gambar',
                  hint: 'Paste link Google Drive / Direct Link',
                  helper: 'Link Google Drive otomatis dikonversi',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'URL Gambar tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Nama Menu'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: _buildInputDecoration('Harga (Rp)'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: _buildInputDecoration(
                        'Kategori',
                        hint: 'Mis: Makanan',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: _buildInputDecoration('Lokasi Resto'),
                validator: (value) =>
                    value!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _regionController,
                decoration: _buildInputDecoration('Daerah / Kota'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration('Deskripsi Menu'),
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: _primaryColor.withOpacityValue(0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text(
                          'Simpan Menu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
