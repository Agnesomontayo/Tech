import 'user.dart';
import 'profession.dart';

class Professionel extends User {

  final int experience;
 final String profession;

  Professionel( {
    required int id,
    required String lastName,
    required String firstName,
    required String phonenumber,
    required String email,
    required String typeprofile,
    required this.experience,
    required this.profession,
  }) : super(id: id, lastName: lastName, firstName: firstName, email: email, phonenumber: phonenumber,typeprofile: typeprofile);

  factory Professionel.fromJson(Map<String, dynamic> json) {
    return Professionel(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      typeprofile: json['typeprofile'],
      experience: json['experience'],
      profession: json['profession'],
    );
  }
}