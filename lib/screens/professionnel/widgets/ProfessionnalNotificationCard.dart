import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/colors.dart';

class ProfessionalNotificationCard extends StatefulWidget {
  final Function(String) onDecision;
  const ProfessionalNotificationCard({
    super.key,
    required this.onDecision,
  });

  @override
  State<ProfessionalNotificationCard> createState() => _ProfessionalNotificationCardState();
}

class _ProfessionalNotificationCardState extends State<ProfessionalNotificationCard> {
  @override
  String? decision; // Stocke la décision actuelle

  void setDecision(String newDecision) {
    setState(() {
      decision = newDecision;
    });
    widget.onDecision(newDecision); // Notifie le parent
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorsData.purple255.withOpacity(0.1),
      ),
      height: 80,
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
                SizedBox(height: 8),
                if (decision == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF0D7C01),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            'Oui',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: ColorsData.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => setDecision("available"),
                      ),
                      SizedBox(width: 10.0),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFD50101),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            'Non',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: ColorsData.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => setDecision("unavailable"),
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
