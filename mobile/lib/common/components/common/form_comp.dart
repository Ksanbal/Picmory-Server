import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class FormComp extends StatelessWidget {
  const FormComp({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength,
    this.autofocus = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: controller,
        style: TypographyToken.titleMd.copyWith(
          color: ColorsToken.neutral[900],
        ),
        textAlign: TextAlign.center,
        maxLength: maxLength,
        buildCounter: maxLength == null
            ? null
            : (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return Center(
                  child: Text(
                    "$currentLength/$maxLength",
                    style: TypographyToken.captionSm.copyWith(
                      color: ColorsToken.neutral[700],
                    ),
                  ),
                );
              },
        cursorColor: ColorsToken.neutral[400],
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TypographyToken.titleMd.copyWith(
            color: ColorsToken.neutral[500],
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorsToken.neutral[400]!,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorsToken.neutral[400]!,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 7,
          ),
        ),
      ),
    );
  }
}
