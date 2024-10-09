import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';

class CardComp extends StatelessWidget {
  const CardComp({super.key, this.child, this.backgroundColor});

  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: EffectsToken.smRadius,
        boxShadow: EffectsToken.shadow1,
        color: backgroundColor ?? ColorsToken.neutral[100],
      ),
      child: child,
    );
  }
}
