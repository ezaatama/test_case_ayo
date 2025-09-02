import 'package:flutter/material.dart';
import 'package:test_case_ayo/utils/constant.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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
          backgroundColor: ColorUI.PRIMARY,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BorderUI.RADIUS_BUTTON),
          ),
        ),
        child: Text(
          text,
          style: TextStyleUI.FILTER_SET.copyWith(
            color: ColorUI.WHITE,
            fontWeight: FontUI.WEIGHT_REGULAR,
          ),
        ),
      ),
    );
  }
}
