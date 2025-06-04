import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String lastName;
  final String firstName;
  final String email;
  final String typeprofile;
  final String phonenumber;
  final String? avatar;
  final String? profile_photo_url;

  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.typeprofile,
    required this.phonenumber,
    this.avatar,
    this.profile_photo_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      typeprofile: json['typeprofile'],
      phonenumber: json['phonenumber'],
      avatar: json['avatar'],
      profile_photo_url: json['profile_photo_url'],
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
      'avatar': avatar,
      'profile_photo_url': profile_photo_url,
    };
  }
}