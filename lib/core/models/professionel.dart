import 'user.dart';
import 'profession.dart';

class Professionel extends User {

  final int experience;
 final String profession;
 final String biography;
 final String availability;

  Professionel( {
    required int id,
    required String lastName,
    required String firstName,
    required String phonenumber,
    required String email,
    required String typeprofile,
    required String? avatar,
    required String? profile_photo_url,
    required this.experience,
    required this.profession,
    required this.biography,
    required this.availability,
  }) : super(id: id, lastName: lastName, firstName: firstName, email: email, phonenumber: phonenumber,typeprofile: typeprofile, avatar: avatar, profile_photo_url: profile_photo_url);

  factory Professionel.fromJson(Map<String, dynamic> json) {
    return Professionel(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      typeprofile: json['typeprofile'],
      avatar: json['avatar'],
      profile_photo_url: json['profile_photo_url'],
      experience: json['experience'],
      profession: json['profession'],
      biography: json['biography'],
      availability: json['availability'],
    );
  }
}