import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui/colors.dart';
import '../../ui/styles.dart';

class BaseTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? expands;
  final bool? enabled;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final double? width;
  final double? height;
  final Widget? label;
  final Widget? prefixIcon;
  final String? errorMessage;

  const BaseTextField({
    this.labelText,
    this.hintText,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    super.key,
    this.expands,
    this.enabled,
    this.maxLines,
    this.minLines,
    this.label,
    this.errorMessage,
    this.width,
    this.height,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          if (labelText != null) SizedBox(height: 8),
          Flexible(
            child: Container(
              height: height,
              constraints: BoxConstraints(
                maxWidth: width ?? double.infinity,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1,
                      color: errorMessage != null
                          ? BaseColors.red
                          : BaseColors.lightGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: TextFormField(
                cursorColor: colorPrimary,
                obscuringCharacter: '⬤',
                style: obscureText ?? false
                    ? TextStyle(
                        letterSpacing: 6,
                        fontSize: 12,
                        color: BaseColors.lightGrey,
                      )
                    : null,
                enabled: enabled,
                controller: controller,
                initialValue: initialValue,
                keyboardType: TextInputType.multiline,
                obscureText: obscureText ?? false,
                onChanged: onChanged,
                expands: expands ?? false,
                textInputAction: TextInputAction.newline,
                maxLines: maxLines,
                minLines: minLines,
                decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: AppTextStyles.body.copyWith(
                    color: Color(0xFF9D9DA4),
                  ),
                ),
              ),
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.exclamationmark_circle,
                    size: 12,
                    color: BaseColors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    errorMessage ?? '',
                    style:
                        AppTextStyles.caption.copyWith(color: BaseColors.red),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  const LabelText({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label ?? '', style: AppTextStyles.menu);
  }
}

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    this.onChanged,
    this.initialValue,
    this.obscureText,
    this.style,
    this.hintText,
    this.hintTextStyle,
    this.maxLines,
    super.key,
    this.inputFormatters,
    this.hideBorder,
    this.errorMessage,
    this.enabled,
    this.suffixIcon,
    this.controller,
  });

  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool? obscureText;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final String? hintText;
  final int? maxLines;
  final bool? hideBorder;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorMessage;
  final bool? enabled;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: enabled,
          onChanged: onChanged,
          style: style,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              isDense: true,
              isCollapsed: true,
              hintMaxLines: 3,
              hintText: hintText,
              border: (hideBorder ?? false) ? InputBorder.none : null),
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          keyboardType: TextInputType.multiline,
          obscureText: obscureText ?? false,
          minLines: (obscureText ?? false) ? 1 : 1,
          maxLines: (obscureText ?? false) ? 1 : maxLines,
        ),
        if (errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              errorMessage ?? '',
              style: AppTextStyles.caption.copyWith(color: Colors.red),
            ),
          )
      ],
    );
  }
}

class MyCustomTextField extends StatefulWidget {
  const MyCustomTextField({super.key});

  @override
  MyCustomTextFieldState createState() => MyCustomTextFieldState();
}

class MyCustomTextFieldState extends State<MyCustomTextField> {
  TextEditingController controller = TextEditingController();
  final key = GlobalKey();
  double iconLeft = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        final RenderBox box =
            key.currentContext?.findRenderObject() as RenderBox;
        final width = box.size.width;
        final textWidth = controller.text.length *
            16.0; // approx width per char, adjust as needed
        iconLeft = textWidth > width ? width : textWidth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextFormField(
          key: key,
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
          ),
        ),
        Positioned(
          left: iconLeft,
          child: Icon(Icons.edit),
        ),
      ],
    );
  }
}
