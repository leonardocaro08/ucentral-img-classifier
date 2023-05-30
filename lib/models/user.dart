import 'dart:convert';

class User {
  String? id;
  String name;
  String last_name;
  String email;
  String phone;
  String password;

  User(
      {this.id,
      required this.name,
      required this.last_name,
      required this.email,
      required this.phone,
      required this.password});

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json['name'],
        last_name: json['last_name'],
        phone: json['phone'],
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'last_name': last_name,
        'phone': phone,
        'email': email,
        'password': password,
      };

  User copy() => User(
        name: name,
        last_name: last_name,
        phone: phone,
        email: email,
        password: password,
      );
}
