import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tech/screens/clients/widgets/CustumDropdown.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/profession_provider.dart';
import '../../clients/widgets/CustumAppBar.dart';
import '../../clients/widgets/EditableDropdownInfo.dart';
import '../../clients/widgets/EditableInfo.dart';
import '../../clients/widgets/ServicePresentationListItem.dart';

class UserInformationsPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phonenumber;
  final String email;
  final int professionId;
 // final String professionName;
  final String experience;
  final String biography;
  final String? imageUrl;
  const UserInformationsPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phonenumber,
    required this.email,
    required this.professionId,
    required this.experience,
    required this.biography,
   // required this.professionName,
    this.imageUrl,
  });

  @override
  State<UserInformationsPage> createState() => _UserInformationsPageState();
}

class _UserInformationsPageState extends State<UserInformationsPage> {
  bool _isEditable = false;
  String baseImageUrl = '';
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  List<dynamic> professions = [];
  late String firstname;
  late String lastName;
  late String phonenumber;
  late String email;
  late int selectedProfessionId;
  //late String professionName;
  late String experience;
  late String availability;
  late String biography;
  String? imageUrl;
  String? selectedValue;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _fetchProfessions () async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      final professionsProvider = Provider.of<ProfessionProvider>(context, listen: false);
      final responseData = await professionsProvider.getManyProfessions();

      setState(() {
        professions = responseData;
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    MultipartFile? avatarFile;
    if (_pickedImage != null && _pickedImage!.path.isNotEmpty) {
      avatarFile = await MultipartFile.fromFile(
        _pickedImage!.path,
        filename: _pickedImage!.path.split('/').last,
      );
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FormData formData = FormData.fromMap({
        '_method': 'PUT',
        'firstName': firstname,
        'lastName': lastName,
        'phonenumber': phonenumber,
        'profession_id': selectedProfessionId,
        'email': email,
        'experience': experience,
        'biography': biography,
        /*if (_pickedImage != null)
          'avatar': await MultipartFile.fromFile(
            _pickedImage!.path,
            filename: _pickedImage!.path.split('/').last,
          ),*/
        if (avatarFile != null) 'avatar': avatarFile,
      });
      print('formData ${firstname} ${lastName} ${phonenumber} ${selectedProfessionId} ${email} ${experience} ${biography}');


      final response = await appProvider.updateUserProfile(
        formData: formData,
      );

      // print('réponse de la demande ${response}');

      if (response != null && response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès')),
        );
        setState(() {
          _isEditable = false;
        });
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la mise à jour')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfessions();
    firstname = widget.firstName;
    lastName = widget.lastName;
    phonenumber = widget.phonenumber;
    selectedProfessionId = widget.professionId;
    experience = widget.experience;
    biography = widget.biography ;
    //professionName = widget.professionName;
    email = widget.email;
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 2.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(25.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: ColorsData.purple266,
                borderRadius: BorderRadius.circular(10.0)),
            child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: ColorsData.purple00A,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              'Informations personnelles',
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: ColorsData.purple00A,
                                  fontSize: 18,
                                  //height: 1.0
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(_isEditable ? Icons.check : Icons.edit),
                            onPressed: () {
                              if (_isEditable) {
                                _submitForm();
                              } else {
                                setState(() => _isEditable = true);
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              AssetsData.p,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),*/
                          imageUrl == null
                              ? Center(child: CircularProgressIndicator())
                              : CircleAvatar(
                            radius: 50,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : (imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : AssetImage(AssetsData.p)) as ImageProvider,
                          ),
                          Spacer(),
                          if (_isEditable)
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _pickImage,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      EditableInfoWidget(
                        label: "Prénom",
                        initialValue: firstname,
                        isEditable: _isEditable,
                        onSave: (value) => firstname = value,
                      ),
                      EditableInfoWidget(
                        label: "Nom",
                        initialValue: lastName,
                        isEditable: _isEditable,
                        onSave: (value) => lastName = value,
                      ),
                      EditableInfoWidget(
                        label: "Numéro de téléphone",
                        initialValue: phonenumber,
                        isEditable: _isEditable,
                        onSave: (value) => phonenumber = value,
                      ),
                      EditableInfoWidget(
                        label: "Email",
                        initialValue: email,
                        isEditable: _isEditable,
                        onSave: (value) => email = value,
                      ),
                      EditableDropdownWidget(
                        label: "Profession",
                        initialValue: selectedProfessionId,
                        isEditable: _isEditable,
                        onChanged: (value) {
                          final selectedProfessions = professions.firstWhere((profession) => profession['id'] == value);
                          setState(() {
                            selectedProfessionId = value;
                          });
                        },
                        options: professions.map((profession) {
                          return DropdownOptions(
                            value: profession['id'],
                            label: profession['label'],
                            imageUrl: profession['profession_category']['image'] != null
                                ? baseImageUrl + '/' + profession['profession_category']['image']
                                : AssetsData.best,
                          );
                        }).toList(),
                      ),
                      EditableInfoWidget(
                        label: "Nombre d'année d'expérience",
                        initialValue: experience,
                        isEditable: _isEditable,
                        onSave: (value) => experience = value,
                      ),
                      EditableInfoWidget(
                        label: 'Biographie',
                        initialValue: biography,
                        isEditable: _isEditable,
                        isMultiline: true,
                        onSave: (val) {
                          biography = val;
                          print('biographie enregistrée: $val');
                        },
                      )
                    ],
                  ),
              )
            ),
          )
        ),
        )
    );
  }
}
    