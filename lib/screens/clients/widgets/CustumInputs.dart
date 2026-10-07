import 'package:flutter/material.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTextInput extends StatelessWidget {
  final String? hintText;
  final BorderRadius borderRadius;
  final TextStyle? styleTopLabel;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final int? maxLine;
  final double? height;
  final String? topLabel;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? initialValue;
  final void Function()? onTap;
  final String obscuringCharacter;
  final void Function(String value)? onFieldSubmitted;
  final bool readOnly;
  final bool enabled;
  final void Function()? onEditingComplete;
  final TextStyle? hintStyle;
  //final  bool isInputFocused;

  const CustomTextInput({
    Key? key,
    required this.hintText,
    this.borderRadius= const BorderRadius.all(Radius.circular(4.0)),
    this.styleTopLabel,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.maxLine =1,
    this.height,
    this.topLabel,
    this.obscureText= false,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.controller,
    this.initialValue,
    this.onTap,
     this.obscuringCharacter= '•',
    this.onFieldSubmitted,
    this.readOnly= false,
    this.enabled= true,
    this.onEditingComplete,
    this.hintStyle,
   // this.isInputFocused=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ColorsData.purple00A,
                width: 2.0,
              ),
            ),
          ),
          child:   Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (prefixIcon != null) Container(
                padding: EdgeInsets.only(bottom: 13), // Espace pour l'icône
                child: prefixIcon!,
              ),
              Expanded(
                child: Container(
                  height: maxLine! > 1 ? height ?? 120 : null, // hauteur fixe pour textarea
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    readOnly: readOnly,
                    obscureText: obscureText,
                    onTap: onTap,
                    initialValue: initialValue,
                    controller: controller,
                    keyboardType: keyboardType,
                    onSaved: onSaved,
                    onChanged: onChanged,
                    validator: validator,
                    maxLines: maxLine! > 1 ? null : 1, // null = illimité si maxLine > 1
                    minLines: maxLine! > 1 ? maxLine : 1,
                    expands: false, // ne pas prendre toute la hauteur
                    decoration: InputDecoration(
                      hintText: hintText,
                      filled: maxLine! > 1,
                      fillColor: maxLine! > 1 ? const Color(0xFFF4F4F4) : null,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: null,
                      suffixIcon: suffix,
                      hintStyle: hintStyle,
                      errorText: errorText,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    style: GoogleFonts.karla(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    cursorColor: ColorsData.black,
                    onFieldSubmitted: onFieldSubmitted,
                  ),
                ),
              ),

            ],
          ),
        ),
       /* Text(
          topLabel: topLabel,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: styleTopLabel ??
              GoogleFonts.karla(
                textStyle: TextStyle(
                  color: ColorsData.black25,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
        ),*/
        if (suffix != null) Container(
          padding: EdgeInsets.only(bottom: 13), // Espace pour l'icône
          child: suffix!,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}