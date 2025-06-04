import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/const/colors.dart';

class DropdownOptions {
  final dynamic value;
  final String label;
  final String? imageUrl;

  DropdownOptions({required this.value, required this.label, this.imageUrl});
}

class EditableDropdownWidget extends StatefulWidget {
  final String label;
  final dynamic initialValue;
  final bool isEditable;
  final List<DropdownOptions> options;
  final void Function(dynamic)? onSave;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onSaved;
  final void Function(dynamic)? onChanged;

  const EditableDropdownWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.isEditable,
    required this.options,
    this.onSave,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  @override
  State<EditableDropdownWidget> createState() => _EditableDropdownWidgetState();
}

class _EditableDropdownWidgetState extends State<EditableDropdownWidget> {
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    print('initial value ${widget.initialValue}');
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = widget.options.firstWhere(
      (opt) => opt.value == _currentValue,
      orElse: () => DropdownOptions(value: null, label: ''),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              widget.isEditable
                  ? DropdownButtonFormField<dynamic>(
                      value: _currentValue,
                      isExpanded: true,
                      validator: widget.validator,
                      onChanged: widget.onChanged,
                      /*(val) {
            setState(() {
              _currentValue = val;
            });
          },*/
                      onSaved: widget.onSave,
                      items: widget.options.map((option) {
                        return DropdownMenuItem(
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
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Row(
                                children: [
                                  (option.imageUrl != null
                                      ? Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: AspectRatio(
                                              aspectRatio: 2.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: option.imageUrl!
                                                        .endsWith('.svg')
                                                    ? SvgPicture.network(
                                                        option.imageUrl!,
                                                        placeholderBuilder:
                                                            (context) => Shimmer
                                                                .fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child: Container(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        fit: BoxFit.contain,
                                                      )
                                                    : option.imageUrl!
                                                            .startsWith('http')
                                                        ? Image.network(
                                                            option.imageUrl!,
                                                            fit: BoxFit.contain,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
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
                                        )
                                      : Container()),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  ))
                                ],
                              ),
                            ) //Text(option.label),
                            );
                      }).toList(),
                      selectedItemBuilder: (context) {
                        return widget.options.map((option) {
                          return Text(option.label);
                        }).toList();
                      },
                      //onChanged: onChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      selectedOption.label,
                      style: const TextStyle(fontSize: 16),
                    ),
            ]),
          )
        ]));
  }
}
