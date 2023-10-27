import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ii_code_gen/ui/colors.dart';

final baseFont = GoogleFonts.poppins();

final styleDrawerLabel = baseFont.copyWith(
  color: BaseColors.darkGrey2,
  fontSize: 12,
);
final styleDrawerTab = baseFont.copyWith(
    color: colorOnDrawerText, fontSize: 18, fontWeight: FontWeight.w500);

class AppTextStyles {
  AppTextStyles._(); // this class is intended to be used as a static class

  static final body = baseFont.copyWith(
    fontSize: 18.0,
    color: black,
    fontWeight: FontWeight.normal,
  );
  static final caption = baseFont.copyWith(
    fontSize: 16.0,
    color: black,
    fontWeight: FontWeight.normal,
  );
  static final button = baseFont.copyWith(
    fontSize: 18.0,
    color: white,
    fontWeight: FontWeight.w500,
  );

  static final bodyText2 = baseFont.copyWith(
    fontSize: 14.0,
    color: black,
    fontWeight: FontWeight.normal,
  );

  static final headline1 = baseFont.copyWith(
    fontSize: 32.0,
    color: black,
    fontWeight: FontWeight.bold,
  );
  static final blackSubtitle = baseFont.copyWith(
    fontSize: 24.0,
    color: black,
    fontWeight: FontWeight.w500,
  );

  static final headline2 = baseFont.copyWith(
    fontSize: 20.0,
    color: black,
    fontWeight: FontWeight.bold,
  );

  static final nav = baseFont.copyWith(
    fontSize: 18.0,
    color: BaseColors.offWhite,
    fontWeight: FontWeight.w500,
  );
  static final title = baseFont.copyWith(
    fontSize: 40.0,
    color: black,
    fontWeight: FontWeight.w500,
  );

  static final menu = baseFont.copyWith(
      color: black, fontSize: 18, fontWeight: FontWeight.w500);
}

class BodyText1 extends StatelessWidget {
  final String text;

  BodyText1(this.text, {this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: AppTextStyles.body.copyWith(
          color: color,
        ));
  }
}

class BodyText2 extends StatelessWidget {
  final String text;

  BodyText2(this.text);

  @override
  Widget build(BuildContext context) {
    return SelectableText(text, style: AppTextStyles.bodyText2);
  }
}

class Headline1 extends StatelessWidget {
  final String text;

  Headline1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.headline1);
  }
}

class Headline2 extends StatelessWidget {
  final String text;

  Headline2(this.text);

  @override
  Widget build(BuildContext context) {
    return SelectableText(text, style: AppTextStyles.headline2);
  }
}

class Caption extends StatelessWidget {
  final String text;

  Caption(this.text);

  @override
  Widget build(BuildContext context) {
    return SelectableText(text, style: AppTextStyles.caption);
  }
}
