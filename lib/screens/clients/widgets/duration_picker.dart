import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final void Function(int durationMinutes) onDurationSelected;

  const DurationPicker({required this.onDurationSelected, super.key});

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int selectedDays = 0;
  int selectedHours = 1;
  int selectedMinutes = 0;

  final List<int> dayOptions = List.generate(31, (index) => index); // 0 à 30 jours
  final List<int> hourOptions = List.generate(24, (index) => index); // 0 à 23 heures
  final List<int> minuteOptions = [0, 15, 30, 45];

  void _confirmDuration() {
    int totalMinutes = selectedDays * 24 * 60 + selectedHours * 60 + selectedMinutes;
    widget.onDurationSelected(totalMinutes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Durée estimée du service', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            DropdownButton<int>(
              value: selectedDays,
              items: dayOptions
                  .map((d) => DropdownMenuItem(value: d, child: Text('$d j')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDays = value!;
                });
              },
            ),
            const SizedBox(width: 16),
            DropdownButton<int>(
              value: selectedHours,
              items: hourOptions
                  .map((h) => DropdownMenuItem(value: h, child: Text('$h h')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHours = value!;
                });
              },
            ),
            const SizedBox(width: 16),
            DropdownButton<int>(
              value: selectedMinutes,
              items: minuteOptions
                  .map((m) => DropdownMenuItem(value: m, child: Text('$m min')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMinutes = value!;
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _confirmDuration,
          child: Text("Valider la durée"),
        )
      ],
    );
  }
}
