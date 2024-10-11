import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class MessagingSmComp extends StatelessWidget {
  const MessagingSmComp({
    super.key,
    required this.text,
    required this.direction,
  });

  final String text;
  final MessagingSmDirection direction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            if (direction == MessagingSmDirection.up) Gap(8),
            Container(
              decoration: const BoxDecoration(
                color: ColorsToken.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: EffectsToken.shadow1,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconsToken(
                    color: ColorsToken.primary,
                  ).dangerCircleBold,
                  Gap(SizeToken.xxs),
                  Text(
                    text,
                    style: TypographyToken.captionSm.copyWith(
                      color: ColorsToken.neutral[800],
                    ),
                  ),
                ],
              ),
            ),
            if (direction == MessagingSmDirection.down)
              ClipPath(
                clipper: _ReverseTriangle(),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsToken.white,
                    boxShadow: EffectsToken.shadow1,
                  ),
                  width: 12,
                  height: 8,
                ),
              )
          ],
        ),
        if (direction == MessagingSmDirection.up)
          ClipPath(
            clipper: _Triangle(),
            child: Container(
              decoration: BoxDecoration(
                color: ColorsToken.primary,
                boxShadow: EffectsToken.shadow1,
              ),
              width: 12,
              height: 8,
            ),
          ),
      ],
    );
  }
}

enum MessagingSmDirection { up, down }

class _Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class _ReverseTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
