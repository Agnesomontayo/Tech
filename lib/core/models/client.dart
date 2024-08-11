import 'user.dart';

class Client extends User {
  //final String typeprofil;

  Client({
    required int id,
    required String nom,
    required String prenom,
    required String phonenumber,
    required String email,
    required String typeprofil,
  }) : super(id: id, nom: nom, prenom: prenom, email: email, phonenumber: phonenumber,typeprofil: typeprofil);

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      typeprofil: json['typeprofil'],
    );
  }
}