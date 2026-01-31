class MenuModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String location;
  final String region;
  final String category;
  final String description;

  MenuModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.region,
    required this.category,
    required this.description,
  });

  factory MenuModel.fromMap(String id, Map<String, dynamic> data) {
    return MenuModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] is double)
              ? data['price']
              : double.tryParse(data['price'].toString()) ?? 0.0,
      location: data['location'] ?? '',
      region: data['region'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'location': location,
      'region': region,
      'category': category,
      'description': description,
    };
  }
}
