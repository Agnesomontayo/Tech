import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/clients_infos/clients_appointments_page.dart';
import 'package:tech/screens/professionnel/clients_infos/clients_requests_page.dart';

import '../../../core/const/colors.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/professionnal_provider.dart';

class ClientDetailsPage extends StatefulWidget {
  final int clientId;
  final int professionalId;
  const ClientDetailsPage({
    super.key,
    required this.clientId,
    required this.professionalId,
  });

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  List<dynamic> requests = [];
  List<dynamic> appointments = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchInteractions();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchInteractions() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getClientProfessionalInteractions(widget.clientId, widget.professionalId);
      setState(() {
        requests = data['service_requests']['data'];
        appointments = data['appointments']['data'];
        _isLoading = false;
      });
      print('Données appointments ${appointments}');
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInfos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            //toolbarHeight: 2.0,
            //automaticallyImplyLeading: false,
            title: const Text('Vos interaction avec ce client'),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: ColorsData.purple00A.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TabBar(
                      labelStyle: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: ColorsData.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: ColorsData.purple00A
                      ),
                      //labelColor: Colors.white,
                      tabs: [
                        Tab(text: 'Demandes ',),
                        Tab(text: 'Rendez-vous',)
                      ]
                  ),
                )
            ),
          ),
          body: TabBarView(
              children: [
                ClientRequestsPage(
                  requests: requests,
                  baseImaeUrl: baseImageUrl,
                ),
                ClientAppointmentsPage(
                  appointments: appointments,
                  baseImaeUrl: baseImageUrl,
                )
              ]
          ),
        )
    );
  }
}
