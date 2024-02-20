import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';

class IconRoundedOutlineButton extends StatelessWidget {
  const IconRoundedOutlineButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.child,
    this.backgroundColor,
    this.outlineColor,
  });

  final Function()? onPressed;
  final Widget icon;
  final Widget child;
  final Color? backgroundColor;
  final Color? outlineColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: child,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          side: BorderSide(
            color: outlineColor ?? ColorFamily.disabledGrey400,
            width: 1,
          ),
        ),
      ),
    );
  }
}
