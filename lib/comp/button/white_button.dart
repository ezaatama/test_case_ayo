import 'package:flutter/material.dart';
import 'package:test_case_ayo/utils/constant.dart';

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.margin,
  });

  final String text;
  final Function() onPressed;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorUI.WHITE,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BorderUI.RADIUS_BUTTON),
          ),
        ),
        child: Text(
          text,
          style: TextStyleUI.SUBTITLE1.copyWith(
            color: ColorUI.PRIMARY,
            fontWeight: FontUI.WEIGHT_SEMI_BOLD,
          ),
        ),
      ),
    );
  }
}
