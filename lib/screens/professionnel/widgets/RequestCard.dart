import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/colors.dart';

class RequestCard extends StatefulWidget {
  final String name;
  final String imagePath;
  final String service;
  final Function(String) onDecision;

  const RequestCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.service,
    required this.onDecision,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
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
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 100,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Permet à la colonne de s'adapter
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: ColorsData.purple00A,
                        ),
                      ),
                    ),
                    if (decision == "accept")
                      Icon(Icons.check_circle, color: Color(0xFF0D7C01), size: 20),
                    if (decision == "refuse")
                      Icon(Icons.cancel, color: Color(0xFFD50101), size: 20),
                  ],
                ),
                SizedBox(height: 5),
                Flexible(
                  child: Text(
                    widget.service,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                          'Accepter',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: ColorsData.white,
                            ),
                          ),
                        ),
                      ),
                        onTap: () => setDecision("accept"),
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
                          'Refuser',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: ColorsData.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => setDecision("refuse"),
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
