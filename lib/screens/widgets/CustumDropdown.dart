import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';

class DropdownOption {
  final dynamic value;
  final String label;
  DropdownOption({required this.value, required this.label});
}

class CustomDropdown extends StatelessWidget {
  final dynamic value;
  final String? topLabel;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onSaved;
  final void Function(dynamic)? onChanged;
  final List<DropdownOption> options;

  CustomDropdown({
    this.value,
    this.topLabel,
    this.validator,
    this.hintText,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.suffix,
    required this.options,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorsData.purple00A,
              width: 2.0,
            ),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (prefixIcon != null)
            Container(
              padding: EdgeInsets.only(bottom: 13), // Espace pour l'icône
              child: prefixIcon!,
            ),
          Expanded(
            child: DropdownButtonFormField<dynamic>(
              onSaved: onSaved,
              validator: validator,
              isExpanded: true,
              value: value,
              isDense: true,
              focusColor: Colors.transparent,
              items: options.map((option) {
                return DropdownMenuItem<dynamic>(
                  value: option.value,
                  child: Text(option.label),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: topLabel,
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: null, // Supprimez ceci pour empêcher l'icône de se répéter
                suffixIcon: suffix, // Ajoutez l'icône souhaitée à droite
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                labelStyle: GoogleFonts.karla(
                  textStyle: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          if (suffix != null) Container(
            padding: EdgeInsets.only(bottom: 13), // Espace pour l'icône
            child: suffix!,
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ]);
  }
}
