import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/notification_provider.dart';

class FrequencySettingsPage extends StatefulWidget {
  final String initialFrequency;
  final String currentAvailability;

  const FrequencySettingsPage({
    super.key,
    required this.initialFrequency,
    required this.currentAvailability,
  });

  @override
  State<FrequencySettingsPage> createState() => _FrequencySettingsPageState();
}

class _FrequencySettingsPageState extends State<FrequencySettingsPage> {
  late String _selectedFrequency;
  bool _isSaving = false;
  late bool _isAvailable;


  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.initialFrequency;
    widget.currentAvailability == 'available' ? _isAvailable = true : _isAvailable = false;
  }

  String get availabilityString => _isAvailable ? 'available' : 'unavailable';

  Future<void> _confirmAndSave() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Es-tu sûr de vouloir enregistrer ces paramètres ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Oui, confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        final success = await _notificationProvider.updateAvailability(status: availabilityString);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Disponibilité mise à jour !')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde')),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);

    try {
      final _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      final success = await _notificationProvider.updateFrequency(frequency: _selectedFrequency);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paramètres sauvegardés !')),
        );
        Navigator.pop(context, _selectedFrequency);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fréquence des rappels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: _isAvailable ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(30),
                    border: Border.all(style: BorderStyle.solid, color: Colors.black)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvailabilityButton(true, 'Disponible'),
                    _buildAvailabilityButton(false, 'Indisponible'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            Text(
              'Choisissez la fréquence des rappels :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            _buildFrequencyOption('1', 'Toutes les heures'),
            _buildFrequencyOption('2', 'Toutes les 2 heures'),
            _buildFrequencyOption('4', 'Toutes les 4 heures'),
            _buildFrequencyOption('6', 'Toutes les 6 heures'),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Annuler'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveSettings,
                  child: _isSaving
                      ? CircularProgressIndicator()
                      : Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _selectedFrequency,
      onChanged: (String? newValue) {
        setState(() {
          _selectedFrequency = newValue!;
        });
      },
    );
  }

 /* Widget _buildAvailabilityButton(bool value, String label) {
    final isSelected = _isAvailable == value;
    final String availabilityValue = value ? 'available' : 'unavailable';

    return GestureDetector(
      onTap: () async {
        if (_isAvailable != value) {
          setState(() {
            _isAvailable = value;
          });
        _confirmAndSave();

        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (_isAvailable ? Colors.green : Colors.red)
                : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }*/

  Widget _buildAvailabilityButton(bool value, String label) {
    final isSelected = _isAvailable == value;
    final String availabilityValue = value ? 'available' : 'unavailable';

    return GestureDetector(
      onTap: () async {
        if (_isAvailable == value) return; // Rien à faire si on clique sur l’état déjà actif

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmation'),
            content: Text('Es-tu sûr de vouloir te mettre "${availabilityValue == 'available' ? 'Disponible' : 'Indisponible'}" ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirmer'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          try {
            final _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
            final success = await _notificationProvider.updateAvailability(status: availabilityValue);

            if (success) {
              setState(() {
                _isAvailable = value;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Statut mis à jour : $availabilityValue')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Échec de la mise à jour')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de la mise à jour')),
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (value ? Colors.green : Colors.red)
                : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



}