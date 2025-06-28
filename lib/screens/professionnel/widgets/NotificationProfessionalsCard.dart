import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/colors.dart';

class NotificationProfessionalCard extends StatefulWidget {
  final Function(String) onDecision;
  final String? currentFrequency;

  const NotificationProfessionalCard({
    super.key,
    required this.onDecision,
    this.currentFrequency,
  });

  @override
  State<NotificationProfessionalCard> createState() => _NotificationProfessionalCardState();
}

class _NotificationProfessionalCardState extends State<NotificationProfessionalCard> {
  String? decision;
  //String? selectedFrequency;

  @override
  void initState() {
    super.initState();
    //selectedFrequency = widget.currentFrequency ?? '2'; // Valeur par défaut: 2 heures
  }

  void _updateAvailability(String newDecision) {
    widget.onDecision(
        newDecision // 'available' ou 'unavailable'
        //selectedFrequency // '1', '2', '4', '6' (heures)
    );

    setState(() {
      decision = newDecision;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorsData.purple255.withOpacity(0.1),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Etes vous disponible ? ',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: ColorsData.purple00A,
                        ),
                      ),
                    ),
                    if (decision == "available")
                      Icon(Icons.check_circle, color: Color(0xFF0D7C01), size: 20),
                    if (decision == "unavailable")
                      Icon(Icons.cancel, color: Color(0xFFD50101), size: 20),
                  ],
                ),

                if (decision == null)

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateAvailability('available'),
                        child: Text('Oui'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () => _updateAvailability('unavailable'),
                        child: Text('Non'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),

                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
