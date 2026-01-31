import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisata_kuliner/models/menu_model.dart';
import 'package:wisata_kuliner/services/favorite_service.dart';
import 'package:wisata_kuliner/services/user_service.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class MenuDetailScreen extends StatefulWidget {
  final MenuModel menu;

  const MenuDetailScreen({super.key, required this.menu});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final UserService _userService = UserService();
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  bool _isFavorite = false;
  String? _userId;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);
  final Color _textSubColor = const Color(0xFF897561);

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      _userId = user.id;
      final isFav = await _favoriteService.isFavorite(user.id, widget.menu.id);
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_userId == null) return;

    if (_isFavorite) {
      await _favoriteService.removeFavorite(_userId!, widget.menu.id);
    } else {
      await _favoriteService.addFavorite(_userId!, widget.menu.id);
    }

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: _primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: _primaryColor,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacityValue(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.black,
                      size: 20,
                    ),
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.menu.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.menu.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.fastfood,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacityValue(0.0),
                          Colors.black.withOpacityValue(0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.menu.name,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: _textMainColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: _primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.menu.location}, ${widget.menu.region}',
                                    style: TextStyle(
                                      color: _textSubColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacityValue(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.menu.category,
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Harga',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSubColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currencyFormat.format(widget.menu.price),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF009688),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textMainColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.menu.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: _textSubColor,
                      ),
                    ),
                    const SizedBox(height: 100), // Space for floating button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: Container( ... ) // Removed as per request
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Removed
    );
  }
}
