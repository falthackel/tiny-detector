class User {
  final int id;
  final String name;
  final String domicile;

  User({required this.id, required this.name, required this.domicile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      domicile: json['domicile'],
    );
  }
}
