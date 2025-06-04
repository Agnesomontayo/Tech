import 'package:flutter/material.dart';

import '../../../core/const/colors.dart';

class AcceptRequestAddCard extends StatefulWidget {
  final bool isReceiver;
  final String content;
  final String senderType;
  final String businessType;

  const AcceptRequestAddCard({
    super.key,
    required this.isReceiver,
    required this.content,
    required this.senderType,
    required this.businessType,
  });

  @override
  State<AcceptRequestAddCard> createState() => _AcceptRequestAddCardState();
}

class _AcceptRequestAddCardState extends State<AcceptRequestAddCard> {

  void _handleAcceptRequest() {
    // À compléter : logique d'acceptation
    print('Demande acceptée : ');
  }

  void _handleRefuseRequest() {
    // À compléter : logique de refus
    print('Demande refusée : ');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Align(
          alignment:
          widget.isReceiver ? Alignment.topLeft : Alignment.topRight,
          child: Column(
              crossAxisAlignment: widget.isReceiver
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
          Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isReceiver
              ? Colors.grey.shade200
              : ColorsData.purple260,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.content,
              style: TextStyle(
                  fontSize: 15, color: Colors.black),
            ),
            if (widget.businessType == 'add_service_request' &&
                widget.senderType == 'receiver')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _handleAcceptRequest(),
                      child: Text('Accepter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.green.shade900,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          _handleRefuseRequest(),
                      child: Text('Refuser'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ))
        ]
    )
    )
    );
  }
}
