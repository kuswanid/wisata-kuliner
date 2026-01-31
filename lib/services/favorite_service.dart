import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisata_kuliner/models/menu_model.dart';
import 'package:wisata_kuliner/services/menu_service.dart';

class FavoriteService {
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance
      .collection('favorites');
  final MenuService _menuService = MenuService();

  Future<List<MenuModel>> getFavorites(String userId) async {
    QuerySnapshot snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .get();

    List<String> menuIds = snapshot.docs.map((doc) {
      return (doc.data() as Map<String, dynamic>)['menuId'] as String;
    }).toList();

    if (menuIds.isEmpty) return [];

    List<MenuModel> allMenus = await _menuService.getMenus();
    return allMenus.where((menu) => menuIds.contains(menu.id)).toList();
  }

  Future<void> addFavorite(String userId, String menuId) async {
    final existing = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('menuId', isEqualTo: menuId)
        .get();

    if (existing.docs.isEmpty) {
      await _favoritesCollection.add({'userId': userId, 'menuId': menuId});
    }
  }

  Future<void> removeFavorite(String userId, String menuId) async {
    final snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('menuId', isEqualTo: menuId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> isFavorite(String userId, String menuId) async {
    final snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('menuId', isEqualTo: menuId)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
