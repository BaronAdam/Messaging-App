class User {
  final int id;
  final String username;
  final String email;
  final String name;

  User(this.id, this.username, this.email, this.name);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        name = json['name'];
}
