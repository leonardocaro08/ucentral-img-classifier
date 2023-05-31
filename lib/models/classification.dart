import 'dart:convert';

class Classification {
  String? id;
  DateTime date;
  String classification_label;
  String user;

  Classification(
      {this.id,
      required this.date,
      required this.classification_label,
      required this.user});

  factory Classification.fromJson(String str) =>
      Classification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Classification.fromMap(Map<String, dynamic> json) => Classification(
      date: DateTime.parse((json['date'])),
      classification_label: json['classification_label'],
      user: json['user']);

  Map<String, dynamic> toMap() => {
        'date': date.toString(),
        'classification_label': classification_label,
        'user': user,
      };

  Classification copy() => Classification(
        date: date,
        classification_label: classification_label,
        user: user,
      );
}
