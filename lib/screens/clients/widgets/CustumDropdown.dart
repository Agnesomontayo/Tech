import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';

class DropdownOption {
  final dynamic value;
  final String label;
  final String? imageUrl;
  DropdownOption({required this.value, required this.label, this.imageUrl});
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
  //final String? dropdownImageUrl;

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
    //this.dropdownImageUrl,
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
              padding: EdgeInsets.only(bottom: 13),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorsData.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        (option.imageUrl != null
                    ? Expanded(
                    child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: option.imageUrl!.endsWith('.svg')
                          ? SvgPicture.network(
                        option.imageUrl!,
                        placeholderBuilder: (context) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        fit: BoxFit.contain,
                      )
                          : option.imageUrl!.startsWith('http')
                          ? Image.network(
                        option.imageUrl!,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                          : Image.asset(
                        option.imageUrl!,
                        fit: BoxFit.contain,
                      ),
                      ),
                    ),
                  ),
                ) : Container()
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option.label,
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      //color: Colors.white,
                                    ),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),

                              ],
                            )
                        )
                      ],
                    ),
                  )//Text(option.label),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return options.map((option) {
                  return Text(option.label);
                }).toList();
              },
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: topLabel,
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: null,
                suffixIcon: suffix,
                errorText: errorText,
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
