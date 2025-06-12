import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../../../core/providers/serviceRequest_provider.dart';
import '../../../core/providers/services_provider.dart';
import '../widgets/CustumDateInputs.dart';
import '../widgets/CustumDropdown.dart';
import '../widgets/CustumInputs.dart';

class AcceptRequestForm extends StatefulWidget {
  final int? serviceRequestId;
  //final String status;
  const AcceptRequestForm({
    super.key,
    this.serviceRequestId,
    //required this.status,
  });

  @override
  State<AcceptRequestForm> createState() => _AcceptRequestFormState();
}

class _AcceptRequestFormState extends State<AcceptRequestForm> {
  final TextEditingController priceController = TextEditingController();
  int? selectedDuration;
  String baseImageUrl = '';
  late int serviceRequestId ;
  late String status;
  late int durationMinutes;
  late int price;
  bool _isLoading = true;
  final List<Map<String, dynamic>> durations = [
    {'label': '2 minutes', 'value': 2},
    {'label': '15 minutes', 'value': 15},
    {'label': '30 minutes', 'value': 30},
    {'label': '45 minutes', 'value': 45},
    {'label': '1 heure', 'value': 60},
    {'label': '1 heeure 15 minutes', 'value': 75},
    {'label': '1h30', 'value': 90},
    {'label': '1 heure 45 minutes', 'value': 105},
    {'label': '2 heures', 'value': 120},
    {'label': '2 heures 15 minutes', 'value': 135},
    {'label': '2 heures 30 minutes', 'value': 150},
    {'label': '2 heures 45 minutes', 'value': 165},
    {'label': '3 heures', 'value': 180},
    {'label': 'Plus de 3 heures', 'value': 0},
  ];

  @override
  Future<void> _submitForm () async {
    try {
      final requestProvider = Provider.of<ServiceRequestProvider>(context, listen: false);
      final request = await requestProvider.updateServiceRequestStatus(
          serviceRequestId,
          status,
          durationMinutes,
          price
      );
      print('Demande mise à jour : $request');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande mise à jour avec succès !')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'envoi de la demande')),
      );
    }
  }

  Future<void> _loadInfos () async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      setState(() {
        _isLoading = false;
      });
    }
    catch (error) {
      print('Erreur de chargement des infos : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  void initState()
  {
    super.initState();
    _loadInfos();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: ColorsData.purple267,
      scrollable: true,
      title:Text(
        'Accepter la demande',
        style: GoogleFonts.karla(
          textStyle: TextStyle(
            color: ColorsData.purple00A,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          CustomDropdown(
            value: selectedDuration,
            hintText: 'La durée approximative du travail',
            onChanged: (value) {
              setState(() {
                selectedDuration = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Durée requise';
              }
              return null;
            },
            options: durations.map((d) {
              return DropdownOption(
                value: d['value'],
                label: d['label'],
              );
            }).toList(),
          ),
          SizedBox(height: 10.0),
          CustomTextInput(
            hintText: 'Entrer le prix',
            controller: priceController,
            keyboardType: TextInputType.number,
            readOnly: false,
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Prix requis';
              }
              return null;
            },
          ),
          SizedBox(height: 10.0),
        ],
      ),

      actions: [
        TextButton(
          child: Text(
            'Annuler',
            style: GoogleFonts.georama(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorsData.purple00A,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'AJOUTER',
            style: GoogleFonts.karla(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            print('les infos avant');
            print('durée: ${selectedDuration}');
            print('prix: ${priceController.text} ');

            serviceRequestId = widget.serviceRequestId!;
            status = 'accepted';
            durationMinutes = selectedDuration!;
            price = int.parse(priceController.text);

          _submitForm();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return ColorsData.purple00A;
                else if (states.contains(MaterialState.disabled))
                  return Colors.grey;
                return ColorsData.purple00A;
              },
            ),
          ),
        )
      ],

    );
  }
}

