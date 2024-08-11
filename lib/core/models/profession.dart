import 'professionel.dart';

class Profession {
  final int id;
  final String label;

  Profession({required this.id, required this.label});

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id'],
      label: json['label'],
    );
  }
}