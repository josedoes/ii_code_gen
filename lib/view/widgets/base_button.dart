import 'package:flutter/material.dart';
import 'package:ii_code_gen/ui/colors.dart';
import 'package:ii_code_gen/ui/styles.dart';

import 'loading/loader.dart';

class BaseButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String buttonText;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final Color? loadingColor;
  final Color? color;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? elevation;
  final bool enabled;
  final Widget? icon;
  final bool isIconResponsive;

  BaseButton({
    this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.textStyle,
    this.buttonStyle,
    this.loadingColor,
    this.enabled = true, // by default, the button is enabled
    super.key,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.elevation,
    this.icon,
    this.isIconResponsive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: height ?? 60,
      width: width,
      child: ElevatedButton(
        onPressed: !enabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
          ),
          elevation: elevation ?? 0,
          backgroundColor: enabled
              ? color ?? colorPrimary
              : Colors.grey, // if not enabled, use grey color
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(6),
                child: AppLoader(),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    isIconResponsive
                        ? size.width < 1200
                            ? icon!
                            : const SizedBox.shrink()
                        : icon!,
                  if (icon != null && !isIconResponsive)
                    const SizedBox(width: 10),
                  isIconResponsive
                      ? size.width < 1200
                          ? const SizedBox.shrink()
                          : Text(buttonText,
                              style: textStyle ?? AppTextStyles.button)
                      : Text(buttonText,
                          style: textStyle ?? AppTextStyles.button),
                ],
              ),
      ),
    );
  }
}
