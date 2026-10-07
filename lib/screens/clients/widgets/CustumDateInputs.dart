import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CustumInputs.dart';

class CustumDateTimeInputs extends StatefulWidget {
  final TextEditingController displayController;
  final TextEditingController valueController;
  final String hintText;
  final bool readOnly;

  const CustumDateTimeInputs({
    super.key,
    this.hintText = 'Sélectionner une date et une heure',
    required this.displayController,
    required this.valueController,
    this.readOnly = true,
  });

  @override
  State<CustumDateTimeInputs> createState() => _CustumDateTimeInputsState();
}

class _CustumDateTimeInputsState extends State<CustumDateTimeInputs> {
  DateTime selectedDateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    widget.displayController.text = DateFormat('dd/MM/yyyy à HH:mm').format(selectedDateTime);
    widget.valueController.text = selectedDateTime.toIso8601String();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = fullDateTime;
          widget.displayController.text = DateFormat('dd/MM/yyyy à HH:mm').format(fullDateTime);
          widget.valueController.text = fullDateTime.toIso8601String();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextInput(
      controller: widget.displayController,
      hintText: widget.hintText,
      readOnly: widget.readOnly,
      onTap: _selectDateTime,
    );
  }
}
