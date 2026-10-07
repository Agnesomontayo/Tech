import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech/core/providers/notification_provider.dart';
import 'package:tech/screens/professionnel/professionnel_home/logbook_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnal_map_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnel_home.dart';
import 'package:tech/screens/professionnel/professionnel_home/request_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/user_page.dart';
import 'package:tech/screens/professionnel/widgets/CustomBottomNavigationBar.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/app_provider.dart';
import '../widgets/NotificationProfessionalsCard.dart';

class MainScreenProfessionnal extends StatefulWidget {
  const MainScreenProfessionnal({super.key});

  @override
  State<MainScreenProfessionnal> createState() =>
      _MainScreenProfessionnalState();
}

class _MainScreenProfessionnalState extends State<MainScreenProfessionnal> {
  int _selectedIndex = 0;
  //Map<String, dynamic> profile = {};
  late String baseImageUrl;
  bool isLoading = true;
  Timer? _notificationTimer;
  late NotificationProvider _notificationService;
  late AppProvider _appProvider;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getScreen(
      int index, Map<String, dynamic> profile, String baseImageUrl)
  {
    switch (index) {
      case 0:
        return ProfessionnelHome(
          profile: profile,
          baseImageUrl: baseImageUrl,
        );
      case 1:
        return LogbookPage(
          profile: profile,
          baseImageUrl: baseImageUrl,
        );
      case 2:
        return RequestPage(
          profile: profile,
          baseImageUrl: baseImageUrl,
        );
      case 3:
        return ProfessionnalUserPage(
          baseImageUrl: baseImageUrl,
        );
      default:
        return ProfessionnelHome(
          profile: profile,
          baseImageUrl: baseImageUrl,
        );
    }
  }

  /*@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationService = Provider.of<NotificationProvider>(context, listen: false);
  }


*//*
  void _startNotificationChecker() {
    _notificationTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkForNotifications();
    });
  }*//*

  Future<void> _checkForNotifications() async {
    try {
      final notifications = await _notificationService.getPendingNotifications();
      if (!mounted) return;
      for (var notification in notifications) {
        final metadata = json.decode(notification['metadata'] ?? '{}');
        if (metadata['trigger_popup'] == true) {
          _showPopup(notification);
          await _notificationService.markAsRead(notification['id']);
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification des notifications: $e');
    }
  }

  *//*void _showPopup(Map<String, dynamic> notification) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: NotificationProfessionalCard(
          onDecision: (decision) async {
            final success = await _notificationService.updateAvailability(
              status: decision,
            );
            if (!mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Disponibilité mise à jour !')),
              );
            }
          },
        ),
      ),
    );
  }
*//*
  void _showPopup(Map<String, dynamic> notification) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(notification['title']),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: NotificationProfessionalCard(
          onDecision: (decision) async {
            final success = await _notificationService.updateAvailability(
              status: decision,
            );
            if (!mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Disponibilité mise à jour !')),
              );
            }
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void startNotificationChecker() async {
    try {
      final settings = await _notificationService.getProfessionalFrequency();
      final frequencyMinutes = int.parse(settings)*60;
        print('frequency ${frequencyMinutes}');
      _notificationTimer?.cancel();
      if (frequencyMinutes > 0)
      _notificationTimer = Timer.periodic(
        Duration(minutes: frequencyMinutes),
            (timer) => _checkForNotifications(),
      );
      else
        _notificationTimer = Timer.periodic(
          Duration(minutes: 10),
              (timer) => _checkForNotifications(),
        );
    } catch (e) {
      print('Erreur récupération fréquence: $e');
      _notificationTimer = Timer.periodic(
        Duration(minutes: 120),
            (timer) => _checkForNotifications(),
      );
    }
  }
  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.initializeBaseImageUrl();
      appProvider.getProfile();
    });
    startNotificationChecker();
  }*/

  @override
  void initState() {
    super.initState();
    _notificationService = Provider.of<NotificationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.initializeBaseImageUrl();
      appProvider.getProfile();
      _startNotificationChecker(); // Déplacé ici après initialisation
    });
  }

  Future<void> _startNotificationChecker() async {
    try {
      final settings = await _notificationService.getProfessionalFrequency();
      final frequency = int.tryParse(settings?.toString() ?? '') ?? 2; // Valeur par défaut 2
      final frequencyMinutes = frequency * 60;

      print('Fréquence configurée: $frequencyMinutes minutes');

      _notificationTimer?.cancel();
      _notificationTimer = Timer.periodic(
        Duration(minutes: frequencyMinutes),
            (timer) => _checkForNotifications(),
      );
    } catch (e) {
      print('Erreur récupération fréquence: $e');
      // Fallback en cas d'erreur
      _notificationTimer = Timer.periodic(
        Duration(minutes: 120), // 2 heures par défaut
            (timer) => _checkForNotifications(),
      );
    }
  }

  Future<void> _checkForNotifications() async {
    try {
      final notifications = await _notificationService.getPendingNotifications();
      if (!mounted) return;

      for (var notification in notifications) {
        try {
          final metadata = json.decode(notification['metadata'] ?? '{}');
          if (metadata['trigger_popup'] == true) {
            if (mounted) {
              _showPopup(notification);
              await _notificationService.markAsRead(notification['id']);
            }
          }
        } catch (e) {
          print('Erreur traitement notification: $e');
        }
      }
    } catch (e) {
      print('Erreur vérification notifications: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur chargement des notifications')),
        );
      }
    }
  }

  void _showPopup(Map<String, dynamic> notification) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(notification['title']),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: NotificationProfessionalCard(
          onDecision: (decision) async {
            try {
              final success = await _notificationService.updateAvailability(
                status: decision,
              );
              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Disponibilité mise à jour !')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur mise à jour disponibilité')),
                );
              }
            }
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      final profile = appProvider.userProfile;
      final isLoading = appProvider.isLoadingProfile;
      final baseImageUrl = appProvider.baseImageUrl;

      print('mainscreenprofile professionnel ${profile}');

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : getScreen(_selectedIndex, profile, baseImageUrl),
        extendBody: true,
        bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
      );
    });
  }
}
