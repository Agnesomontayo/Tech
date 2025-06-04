import 'user.dart';

class Client extends User {
  //final String typeprofil;

  Client({
    required int id,
    required String lastName,
    required String firstName,
    required String phonenumber,
    required String email,
    required String typeprofile,
    required String? avatar,
    required String? profile_photo_url,
  }) : super(id: id, lastName: lastName, firstName: firstName, email: email, phonenumber: phonenumber,typeprofile: typeprofile, avatar: avatar, profile_photo_url: profile_photo_url);

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      typeprofile: json['typeprofile'],
      avatar: json['avatar'],
      profile_photo_url: json['profile_photo_url'],
    );
  }
}