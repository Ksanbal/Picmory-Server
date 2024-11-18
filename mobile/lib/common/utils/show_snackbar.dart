import 'package:flutter/material.dart';
import 'package:picmory/common/components/common/messaging_md_comp.dart';

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
      content: MessagingMdComp(
        text: message,
        onPressed: () {
          if (onPressedAction != null) {
            onPressedAction();
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
      ),
    ),
  );
}
