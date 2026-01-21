class UserModel {
  final String uid;
  final String name;
  final String email;
  final String provider;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.provider,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'provider': provider};
  }
}
