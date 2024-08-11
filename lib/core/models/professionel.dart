import 'user.dart';
import 'profession.dart';

class Professionel extends User {
 // final String typeprofil;
  final int experience;
 final String profession;

  Professionel( {
    required int id,
    required String nom,
    required String prenom,
    required String phonenumber,
    required String email,
    required String typeprofil,
    required this.experience,
    required this.profession,
  }) : super(id: id, nom: nom, prenom: prenom, email: email, phonenumber: phonenumber,typeprofil: typeprofil);

  factory Professionel.fromJson(Map<String, dynamic> json) {
    return Professionel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      typeprofil: json['typeprofil'],
      experience: json['experience'],
      profession: json['profession'],
    );
  }
}