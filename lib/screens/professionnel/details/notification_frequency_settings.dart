import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/notification_provider.dart';

class FrequencySettingsPage extends StatefulWidget {
  final String initialFrequency;

  const FrequencySettingsPage({
    super.key,
    required this.initialFrequency,
  });

  @override
  State<FrequencySettingsPage> createState() => _FrequencySettingsPageState();
}

class _FrequencySettingsPageState extends State<FrequencySettingsPage> {
  late String _selectedFrequency;
  bool _isSaving = false;

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
  void initState() {
    super.initState();
    _selectedFrequency = widget.initialFrequency;
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

}