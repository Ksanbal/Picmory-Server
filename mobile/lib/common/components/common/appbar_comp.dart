import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class AppBarComp extends StatelessWidget {
  const AppBarComp({
    super.key,
    this.title,
    this.titleColor,
    required this.actions,
    this.reverse = false,
  });

  final String? title;
  final Color? titleColor;
  final List<AppBarAction> actions;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(
        gradient: reverse
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff0D0F13).withOpacity(0.40),
                  Color(0xff0D0F13).withOpacity(0),
                ],
              )
            : null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToken.m,
        ),
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Navigator.canPop(context)
                      ? IconButtonComp(
                          onPressed: context.pop,
                          icon: IconsToken(
                            color: reverse ? ColorsToken.white : ColorsToken.black,
                          ).altArrowLeftLinear,
                          backgroundColor:
                              reverse ? ColorsToken.neutralAlpha[500]! : Colors.transparent,
                        )
                      : SizedBox(),
                  Row(
                    children: actions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(left: SizeToken.xs),
                        child: IconButtonComp(
                          onPressed: action.onPressed,
                          icon: reverse ? action.reverseIcon ?? action.icon : action.icon,
                          backgroundColor:
                              reverse ? ColorsToken.neutralAlpha[500]! : Colors.transparent,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            Align(
              alignment: Navigator.canPop(context) ? Alignment.center : Alignment.centerLeft,
              child: Text(
                title ?? '',
                style: TypographyToken.textMd.copyWith(
                  color: titleColor ?? (reverse ? ColorsToken.white : ColorsToken.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarAction {
  const AppBarAction({
    required this.icon,
    required this.onPressed,
    this.reverseIcon,
  });

  final SvgPicture icon;
  final Function() onPressed;
  final SvgPicture? reverseIcon;
}
