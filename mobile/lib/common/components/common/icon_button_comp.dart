import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';

class IconButtonComp extends StatelessWidget {
  const IconButtonComp({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color = ColorsToken.neutral,
    this.backgroundColor = Colors.transparent,
  });

  final void Function() onPressed;
  final Widget icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: EffectsToken.pillRadius,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: SizeToken.n3xl / 2,
        child: icon,
      ),
    );
  }
}
