import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/details/client_details_page.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';

class Clientcard extends StatefulWidget {
  final String name;
  final String imagePath;
  final String phoneNumber;
  final int clientId;
  final int professionalId;

  const Clientcard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.phoneNumber,
    required this.clientId,
    required this.professionalId,
  });

  @override
  State<Clientcard> createState() => _ClientcardState();
}

class _ClientcardState extends State<Clientcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: ColorsData.purple255.withOpacity(0.1),
      ),
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: widget.imagePath != null
                      ? NetworkImage(widget.imagePath)
                      : AssetImage(AssetsData.best) as ImageProvider,
                  fit: BoxFit.fill
              ),
            ),
          ),
          Expanded(
            child: Column(
            children: [
              Text(
                widget.name,
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: ColorsData.purple00A
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(
                widget.phoneNumber,
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: ColorsData.grey6b.withOpacity(0.6)
                  )
                )
              )
            ],
            )
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: ColorsData.purple00A,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClientDetailsPage(
                          clientId: widget.clientId,
                          professionalId: widget.professionalId,
                        )),
                      );
                    },
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
