import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisata_kuliner/models/menu_model.dart';
import 'package:wisata_kuliner/screens/menu_detail_screen.dart';
import 'package:wisata_kuliner/services/favorite_service.dart';
import 'package:wisata_kuliner/services/user_service.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final UserService _userService = UserService();
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  Future<List<MenuModel>>? _favoritesFuture;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);
  final Color _textSubColor = const Color(0xFF897561);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final user = await _userService.getCurrentUser();
    if (user != null) {
      if (mounted) {
        setState(() {
          _favoritesFuture = _favoriteService.getFavorites(user.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Menu Favorit',
          style: TextStyle(
            color: _textMainColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: _favoritesFuture == null
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : FutureBuilder<List<MenuModel>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: _primaryColor),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final favorites = snapshot.data ?? [];

                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: _textSubColor.withOpacityValue(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada menu favorit',
                          style: TextStyle(color: _textSubColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: favorites.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildFavoriteCard(favorites[index]);
                  },
                );
              },
            ),
    );
  }

  Widget _buildFavoriteCard(MenuModel menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetailScreen(menu: menu)),
        ).then((_) => _loadFavorites());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade50),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                image: menu.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(menu.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: menu.imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: TextStyle(
                      color: _textMainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: _primaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${menu.location}, ${menu.region}',
                          style: TextStyle(color: _textSubColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currencyFormat.format(menu.price),
                    style: const TextStyle(
                      color: Color(0xFF009688),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: _primaryColor.withOpacityValue(0.5),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
