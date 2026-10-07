import 'professionel.dart';

class Profession {
  final int id;
  final String label;
  final String? description;

  Profession({required this.id, required this.label, this.description});

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id'],
      label: json['label'],
      description: json['description'],
    );
  }
}