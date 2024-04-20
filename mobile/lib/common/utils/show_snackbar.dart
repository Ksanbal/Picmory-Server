import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';

showSnackBar(
  BuildContext context,
  String message, {
  double bottomPadding = 20,
  String? actionTitle,
  Function()? onPressedAction,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.of(context).padding.bottom + bottomPadding,
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ColorFamily.textGrey700.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: const TextSmStyle(),
            ),
            if (actionTitle != null)
              InkWell(
                onTap: onPressedAction ?? ScaffoldMessenger.of(context).hideCurrentSnackBar,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ColorFamily.textGrey600,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Text(
                    actionTitle,
                    style: const CaptionSmStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
