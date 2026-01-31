import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisata_kuliner/models/menu_model.dart';

class MenuService {
  final CollectionReference _menusCollection =
      FirebaseFirestore.instance.collection('menus');

  Future<List<MenuModel>> getMenus() async {
    QuerySnapshot snapshot = await _menusCollection.get();
    return snapshot.docs.map((doc) {
      return MenuModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> addMenu(MenuModel menu) async {
    await _menusCollection.add(menu.toMap());
  }

  Future<void> updateMenu(MenuModel menu) async {
    await _menusCollection.doc(menu.id).update(menu.toMap());
  }

  Future<void> deleteMenu(String id) async {
    await _menusCollection.doc(id).delete();
  }

  Future<List<MenuModel>> searchMenus(String query) async {
    // Note: Firestore basic search is limited. 
    // Ideally use Algolia or client-side filtering for small datasets.
    // For this task, we'll fetch all and filter client-side or use basic startsWith logic if applicable.
    // Here implementing a simple client-side filter for demonstration.
    List<MenuModel> allMenus = await getMenus();
    return allMenus.where((menu) {
      final nameLower = menu.name.toLowerCase();
      final regionLower = menu.region.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) || regionLower.contains(queryLower);
    }).toList();
  }
}
