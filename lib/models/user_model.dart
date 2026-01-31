class UserModel {
  final String id;
  final String city;
  final String email;
  final String name;
  final String role;
  final String photoUrl;
  final String backgroundUrl;

  UserModel({
    required this.id,
    required this.city,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl = '',
    this.backgroundUrl = '',
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      city: data['city'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'user',
      photoUrl: data['photoUrl'] ?? '',
      backgroundUrl: data['backgroundUrl'] ?? '',
    );
  }
}
