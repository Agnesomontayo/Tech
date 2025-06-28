import 'package:flutter/material.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/string.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfcustomLogo extends StatelessWidget {
  final Axis direction;
  final double width;
  final bool showImageLogo;
  final double height;
  final double fontSize;
  const ProfcustomLogo(
      {super.key,
        this.direction = Axis.vertical,
        this.width = 60,
        this.height = 75,
        this.showImageLogo = true,
        this.fontSize = 28});

  @override
  Widget build(BuildContext context) {

    final Widget logo = showImageLogo
        ? Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(

          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SvgPicture.asset(
          AssetsData.logo,
        ),
      ),
    )
        : const SizedBox.shrink();

    final text = GradientText(
      StringData.appName,
      style: GoogleFonts.brunoAce(
       textStyle: TextStyle(
          color: ColorsData.white,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        )
      ),

      gradient: LinearGradient(
        colors: [
          ColorsData.white,
          ColorsData.greyCA,
        ],
      ),
    );
    return direction == Axis.vertical
        ? Column(
      children: [
        logo,
        const SizedBox(
          height: 0,
        ),
         text
      ],
    )
        : Row(
      children: [
        logo,
        const SizedBox(
          width: 20,
        ),
        text
      ],
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        super.key,
        required this.gradient,
        this.style,
      });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
