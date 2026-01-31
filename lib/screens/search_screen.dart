import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisata_kuliner/models/menu_model.dart';
import 'package:wisata_kuliner/screens/menu_detail_screen.dart';
import 'package:wisata_kuliner/services/menu_service.dart';
import 'package:wisata_kuliner/utils/color_extensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MenuService _menuService = MenuService();
  final TextEditingController _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  List<MenuModel> _searchResults = [];
  List<MenuModel> _allMenus = [];
  bool _isLoading = false;

  // Colors
  final Color _primaryColor = const Color(0xFFFF6B00);
  final Color _backgroundColor = const Color(0xFFFFF8F2);
  final Color _textMainColor = const Color(0xFF2D2420);
  final Color _textSubColor = const Color(0xFF897561);

  @override
  void initState() {
    super.initState();
    _loadAllMenus();
  }

  Future<void> _loadAllMenus() async {
    // Only show loading if we don't have menus yet
    if (_allMenus.isEmpty) {
      setState(() => _isLoading = true);
    }
    try {
      final menus = await _menuService.getMenus();
      if (mounted) {
        setState(() {
          _allMenus = menus;
          _isLoading = false;
        });
        if (_searchController.text.isNotEmpty) {
          _performSearch();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Error loading menus: $e');
    }
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final lowerQuery = query.toLowerCase().trim();

    setState(() {
      _searchResults = _allMenus.where((menu) {
        return menu.name.toLowerCase().contains(lowerQuery) ||
            menu.region.toLowerCase().contains(lowerQuery) ||
            menu.category.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacityValue(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _performSearch(),
                  onSubmitted: (_) => _performSearch(),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari kuliner favoritmu...',
                    hintStyle: TextStyle(
                      color: _textSubColor.withOpacityValue(0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.search, color: _primaryColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 20,
                              color: _textSubColor,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: _primaryColor),
                    )
                  : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: _textSubColor.withOpacityValue(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? 'Mulai pencarian Anda'
                                : 'Menu tidak ditemukan',
                            style: TextStyle(color: _textSubColor),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: _searchResults.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildResultCard(_searchResults[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(MenuModel menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetailScreen(menu: menu)),
        );
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
                  Text(
                    '${menu.location}, ${menu.region}',
                    style: TextStyle(color: _textSubColor, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currencyFormat.format(menu.price),
                        style: const TextStyle(
                          color: Color(0xFF009688),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacityValue(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
