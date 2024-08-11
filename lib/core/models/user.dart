import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String typeprofil;
  final String phonenumber;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.typeprofil,
    required this.phonenumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      typeprofil: json['typeprofil'],
      phonenumber: json['phonenumber'],
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'phonenumber': phonenumber,
      'typeprofil': typeprofil,
    };
  }
}