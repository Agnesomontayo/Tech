import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tech/core/providers/review_provider.dart';
import '../../../core/const/colors.dart';
import '../../../core/models/review.dart';

class ReviewForm extends StatefulWidget {
  final int clientId;
  final int professionalId;
  //final String baseUrl;
  //final String userToken;
  //final VoidCallback? onReviewSubmitted;

  const ReviewForm({
    super.key,
    required this.clientId,
    required this.professionalId,
    //required this.baseUrl,
    //required this.userToken,
    //this.onReviewSubmitted,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  bool _isLoading = true;
  double _rating = 2.5;
  OpinionType? _selectedOpinion;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedOpinion = _getOpinionFromRating(_rating);
  }

  OpinionType _getOpinionFromRating(double rating) {
    if (rating <= 1.0) {
      return OpinionType.veryBad;
    } else if (rating <= 2.0) {
      return OpinionType.bad;
    } else if (rating <= 3.0) {
      return OpinionType.good;
    } else { // rating > 3.0
      return OpinionType.excellent;
    }
  }

  // Gère la soumission du formulaire
  Future<void> _submitReview() async {
    if (_selectedOpinion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une opinion.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final review = Review(
      clientId: widget.clientId,
      professionalId: widget.professionalId,
      rate: _rating,
      opinion: _selectedOpinion!,
      comment: _commentController.text.trim().isNotEmpty ? _commentController.text.trim() : null,
    );

    try {
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      final response = reviewProvider.addNewReview(
        review
      );
      /*await http.post(
        Uri.parse('http://${widget.baseUrl}:8000/api/reviews'), // L'URL de votre endpoint d'API
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.userToken}',
          'Accept': 'application/json',
        },
        body: jsonEncode(review.toJson()),
      );*/

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revue soumise avec succès !')),
        );
        //widget.onReviewSubmitted?.call();
        Navigator.of(context).pop();
      } else {
        //final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de soumission de la revue: ${response.toString()}')),
        );
        print('Error submitting review: ${response.toString()}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau: $e')),
      );
      print('Network error submitting review: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: ColorsData.white,
      scrollable: true,
      title:Text(
        'Qu\'avez-vous pensé de ce pestataire?',
        style: GoogleFonts.karla(
          textStyle: TextStyle(
            color: ColorsData.purple00A,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        textAlign: TextAlign.center,
      ),
      content: /*_isLoading
          ? Center(child: CircularProgressIndicator())
          :*/ Column(
        children: [
          Center(
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                  _selectedOpinion = _getOpinionFromRating(rating);
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          // Emoji opinion selection
          Text(
            'Votre avis :',
            style: GoogleFonts.karla(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: OpinionType.values.map((opinion) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOpinion = opinion;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedOpinion == opinion
                        ? ColorsData.purple00A.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedOpinion == opinion
                          ? ColorsData.purple00A
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        opinion.toEmoji(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        opinion.toLabel(),
                        style: GoogleFonts.karla(
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Comment text field
          TextFormField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Commentaire (optionnel)',
              hintText: 'Décrivez votre expérience...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorsData.purple00A, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Submit Button
         /* Center(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsData.purple00A,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Soumettre la revue',
                style: GoogleFonts.karla(
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),*/
        ],
      ),

      actions: [
        TextButton(
          child: Text(
            'Annuler',
            style: GoogleFonts.georama(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorsData.purple00A,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Noter',
            style: GoogleFonts.karla(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onPressed: _submitReview,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return ColorsData.purple00A;
                else if (states.contains(MaterialState.disabled))
                  return Colors.grey;
                return ColorsData.purple00A; // couleur de fond par défaut
              },
            ),
          ),
        )
      ],

    );
  }
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
