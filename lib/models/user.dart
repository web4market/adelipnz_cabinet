class User {
  final int id;
  final String login;
  final String? email;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.login,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}