import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String lastName;
  final String firstName;
  final String email;
  final String typeprofile;
  final String phonenumber;

  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.typeprofile,
    required this.phonenumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      typeprofile: json['typeprofile'],
      phonenumber: json['phonenumber'],
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'phonenumber': phonenumber,
      'typeprofile': typeprofile,
    };
  }
}