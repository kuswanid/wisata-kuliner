class FavoriteModel {
  final String id;
  final String userId;
  final String menuId;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.menuId,
  });

  factory FavoriteModel.fromMap(String id, Map<String, dynamic> data) {
    return FavoriteModel(
      id: id,
      userId: data['userId'] ?? '',
      menuId: data['menuId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'menuId': menuId,
    };
  }
}
