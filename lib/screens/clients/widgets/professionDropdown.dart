import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../core/models/profession.dart';

class ProfessionDropdown extends StatefulWidget {
  @override
  _ProfessionDropdownState createState() => _ProfessionDropdownState();
}

class _ProfessionDropdownState extends State<ProfessionDropdown> {
  List<Profession> professions = [];
  Profession? selectedProfession;

  @override
  void initState() {
    super.initState();
    fetchProfessions();
  }

  Future<void> fetchProfessions() async {
    try {
      final response = await Dio().get('https://your-api-url/professions');
      List<dynamic> data = response.data;
      List<Profession> professionList = data.map((item) => Profession.fromJson(item)).toList();
      setState(() {
        professions = professionList;
      });
    } catch (error) {
      // Gérer les erreurs
      print('Erreur lors de la récupération des professions : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Profession>(
      value: selectedProfession,
      onChanged: (value) {
        setState(() {
          selectedProfession = value;
        });
      },
      items: professions.map<DropdownMenuItem<Profession>>((Profession profession) {
        return DropdownMenuItem<Profession>(
          value: profession,
          child: Text(profession.label),
        );
      }).toList(),
      hint: Text('Sélectionner une profession'),
    );
  }
}