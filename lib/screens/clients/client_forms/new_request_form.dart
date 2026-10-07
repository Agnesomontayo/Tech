import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/core/providers/serviceRequest_provider.dart';

import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/services_provider.dart';
import '../../../core/services/dio_service.dart';
import '../widgets/CustumInputs.dart';
import '../widgets/CustumDropdown.dart';
import '../widgets/CustumDateInputs.dart';
import 'package:provider/provider.dart';

import '../widgets/EditableInfo.dart';

class NewRequestFormModal extends StatefulWidget {
  final int? serviceId;
  final String? serviceLabel;
  final String? professionalName;
  final int? professionalId;
  final int clientId;
  final String? clientName;
  const NewRequestFormModal({
    super.key,
    this.serviceId,
    this.professionalId,
    this.serviceLabel,
    this.professionalName,
    required this.clientId,
    this.clientName,
  });

  @override
  State<NewRequestFormModal> createState() => _NewRequestFormModalState();
}

class _NewRequestFormModalState extends State<NewRequestFormModal> {
  final TextEditingController sideNoteController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController professionalController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController displayScheduleAtController = TextEditingController();
  final TextEditingController valueScheduleAtController = TextEditingController();
  List<dynamic> professionals = [];
  List<dynamic> services = [];
 /* Map <String, dynamic>? oneService;
  Map <String, dynamic>? oneProfessional;*/
  Map <String, dynamic>? _profile;
  int? selectedProfessionalId;
  int? selectedServiceId;
  String baseImageUrl = '';
  bool _isLoading = true;
  int? clientId;
  int? serviceId;
  int? professionalId;
  String? side_note;
  DateTime? schedule_at;
  final DioService _dioService = DioService(baseUrl: '', token: '');


  Future<bool> _askForLocationPermission(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Partager votre position"),
        content: Text("Voulez-vous partager votre position actuelle avec le professionnel pour faciliter le rendez-vous ?"),
        actions: [
          TextButton(
            child: Text("Non merci"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Autoriser"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _getAndSaveClientLocation() async {
    try {
      // Vérifier les permissions
      String baseUrl = await ApiHelper.getApiUrl();
      final status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('Permission de localisation refusée');
      }

      // Récupérer la position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Envoyer la position au backend
      final response = await _dioService.post(
        url: '${baseUrl}/update-location',
        body: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );

      if (response == null) {
        throw Exception('Erreur sauvegarde position');
      }
    } catch (e) {
      print('Erreur récupération position: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de récupérer votre position')),
      );
    }
  }


  Future<void> _fetchServices() async {
    try {
      if (widget.serviceId == null) {
      final serviceProvider = Provider.of<ServicesProvider>(context, listen: false);
      final data = await serviceProvider.getManyServices();
      setState(() {
      services = data;
      });
      } else if ( widget.serviceId != null) {
        /*final serviceProvider = Provider.of<ServicesProvider>(context, listen: false);
        final data = await serviceProvider.getOneService(widget.serviceId!);*/
        setState(() {
          //oneService = data;
          serviceController.text = widget.serviceLabel!;
        });
      }
    } catch (error) {
      print('Erreur de chargement des services : $error');

    }
  }
  Future<void> _fetchProfessionals() async {
    try {
      if (widget.professionalId == null) {
        final int existingServiceId = widget.serviceId!;
        final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
        final data = await professionalProvider.getProfessionalsByService(existingServiceId);
        setState(() {
          professionals = data;
        });
      } else if (widget.professionalId != null) {
        /*final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
        final data = await professionalProvider.getOneProfessional(widget.professionalId!);*/
        setState(() {
         // oneProfessional = data;
          professionalController.text = widget.professionalName!;
        });
      }
    } catch (error) {
      print('Erreur de chargement des services : $error');

    }
  }

  Future<void> _submitForm () async {
    try {
      print('les infos pendant'
          ' ${clientId}, ${professionalId}, ${serviceId}, ${side_note}, ${schedule_at}');
      final requestProvider = Provider.of<ServiceRequestProvider>(context, listen: false);
      final request = await requestProvider.addServiceRequest(
        clientId!,
        professionalId!,
        serviceId!,
        schedule_at!,
        side_note!,
      );

      if (widget.clientId != null) {
        final positionAllowed = await _askForLocationPermission(context);
        if (positionAllowed) {
          await _getAndSaveClientLocation();
        }
      }

      print('Demande créée : $request');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande envoyée avec succès !')),
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
      /*final appProvider = Provider.of<AppProvider>(context, listen: false);
      final data = await appProvider.getProfile();*/
      setState(() {
        //_profile = data;
        clientController.text = widget.clientName!;
        _isLoading = false;
      });
      _fetchServices();
      _fetchProfessionals();
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
        'Nouvelle demande',
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
         CustomTextInput(
              hintText: 'Nom du client',
              controller: clientController,
              keyboardType: TextInputType.name,
              obscureText: false,
              readOnly: true,
          ),
          SizedBox(height: 10.0),
          (widget.professionalId == null
          ? CustomDropdown(
            value: selectedProfessionalId,
            hintText: 'Select a professional',
            onChanged: (value) {
              final selectedProfessional = professionals.firstWhere((professional) => professional['id'] == value);
              setState(() {
                selectedProfessionalId = value;
              });
            },

            options: professionals.map((professional) {
              return DropdownOption(
                value: professional['id'],
                label: professional['user']['firstName']+' '+professional['user']['lastName'],
                imageUrl: professional['user']['avatar'] != null
                    ? baseImageUrl + '/' + professional['user']['avatar']
                    : professional['user']['profile_photo_url'],
              );
            }).toList(),
          ) :  CustomTextInput(
              hintText: 'Nom et prénom',
              controller: professionalController,
              keyboardType: TextInputType.name,
              readOnly: true,
              obscureText: false,
          )),
          SizedBox(height: 10.0),
          (widget.serviceId == null
              ? CustomDropdown(
            value: selectedServiceId,
            hintText: 'Select a service',
            onChanged: (value) {
              final selectedService = services.firstWhere((service) => service['id'] == value);
              setState(() {
                selectedServiceId = value;
              });
            },

            options: services.map((service) {
              return DropdownOption(
                value: service['id'],
                label: service['label'],
                imageUrl: service['image'] != null
                    ? baseImageUrl + '/' + service['image']
                    : AssetsData.best,
              );
            }).toList(),
          ) :  CustomTextInput(
            hintText: 'Nom du service',
            controller: serviceController,
            keyboardType: TextInputType.name,
            readOnly: true,
            obscureText: false,
          )),
          CustumDateTimeInputs(
          displayController: displayScheduleAtController,
          valueController: valueScheduleAtController,
        ),
          SizedBox(height: 10.0),
          CustomTextInput(
            hintText: 'Voulez vous ajouter quelque chose ?',
            controller: sideNoteController,
            maxLine: 5,
            height: 150,
            readOnly: false,
            obscureText: false,
          ),
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
            print('les infos avant ${clientId}, ${professionalId}, ${serviceId}, ${side_note}, ${schedule_at}');
            print('Nom client: ${clientController.text}, id : ${widget.clientId}');
            print('nom professionel: ${professionalController.text} ou selected : $selectedProfessionalId');
            print('nom service : ${serviceController.text} ou selected : $selectedServiceId');
            print('schedulled at: ${displayScheduleAtController.text} ou value : ${valueScheduleAtController.text}');
            print('side_note: ${sideNoteController.text}');

            clientId = widget.clientId;
            serviceId = widget.serviceId == null ? selectedServiceId : widget.serviceId;
            professionalId = widget.professionalId == null ? selectedProfessionalId : widget.professionalId;
            side_note = sideNoteController.text;
            schedule_at = DateTime.parse(valueScheduleAtController.text);
            print('les infos après ${clientId}, ${professionalId}, ${serviceId}, ${side_note}, ${schedule_at}');
            _submitForm();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return ColorsData.purple00A;
                else if (states.contains(MaterialState.disabled))
                  return Colors.grey;
                return ColorsData.purple00A; // couleur de fond par défaut
              },
            ),
          ),
        )
      ],

    );
  }
}

