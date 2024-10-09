import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class AppBarComp extends AppBar {
  AppBarComp({
    super.key,
    required String title,
    required List<Widget> actions,
    required BuildContext context,
  }) : super(
          automaticallyImplyLeading: false,
          leading: Navigator.canPop(context)
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: SizeToken.m,
                  ),
                  child: IconButtonComp(
                    onPressed: context.pop,
                    icon: IconsToken().altArrowLeftLinear,
                  ),
                )
              : null,
          centerTitle: Navigator.canPop(context),
          title: Padding(
            padding: EdgeInsets.only(
              left: Navigator.canPop(context) ? 0 : SizeToken.m,
            ),
            child: Text(
              title,
              style: TypographyToken.textMd,
            ),
          ),
          actions: [
            ...actions.map(
              (action) => Padding(
                padding: EdgeInsets.only(
                  left: SizeToken.xs,
                ),
                child: action,
              ),
            ),
            Gap(SizeToken.m),
          ],
        );
}
