import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../clients/widgets/CustumAppBar.dart';
import '../../clients/widgets/EditableInfo.dart';
import '../../clients/widgets/ServicePresentationListItem.dart';

class UserInformationsPage extends StatefulWidget {
  const UserInformationsPage({super.key});

  @override
  State<UserInformationsPage> createState() => _UserInformationsPageState();
}

class _UserInformationsPageState extends State<UserInformationsPage> {
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: ColorsData.purple00A,
                          size: 30,
                        ), // Icône de retour
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child:  Text(
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
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  EditableInfoWidget(
                    label: "Prénom",
                    initialValue: "John",
                    onSave: (value) {
                      print("Prénom sauvegardé : $value");
                    },
                  ),
                  EditableInfoWidget(
                    label: "Nom",
                    initialValue: "DOE",
                    onSave: (value) {
                      print("Nom sauvegardé : $value");
                    },
                  ),
                  EditableInfoWidget(
                    label: "Profession",
                    initialValue: "Menuisier",
                    onSave: (value) {
                      print("Profession sauvegardée : $value");
                    },
                  ),
                  EditableInfoWidget(
                    label: "Numéro de téléphone",
                    initialValue: "+229 67338615",
                    onSave: (value) {
                      print("Numéro de téléphone sauvegardé : $value");
                    },
                  ),
                  EditableInfoWidget(
                    label: "Email",
                    initialValue: "john.doe@example.com",
                    onSave: (value) {
                      print("Email sauvegardé : $value");
                    },
                  ),
                ],
              ),
            ),
          )
        ),
        )
    );
  }
}
    