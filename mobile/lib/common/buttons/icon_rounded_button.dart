import 'package:flutter/material.dart';

class IconRoundedButton extends StatelessWidget {
  const IconRoundedButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.child,
    this.backgroundColor,
    this.isDense = false,
  });

  final Function()? onPressed;
  final Widget icon;
  final Widget child;
  final Color? backgroundColor;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isDense ? null : double.infinity,
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
        ),
      ),
    );
  }
}
