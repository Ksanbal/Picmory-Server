import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsToken.neutral[50],
        leading: IconButtonComp(
          onPressed: context.pop,
          icon: IconsToken().altArrowLeftLinear,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // 구분선
            Divider(color: ColorsToken.neutral[200]),
            Gap(SizeToken.m),
            // 탈퇴
            ListTile(
              onTap: () => vm.withdraw(context),
              contentPadding: EdgeInsets.zero,
              title: Text(
                "회원탈퇴",
                style: TypographyToken.textSm,
              ),
              trailing: IconsToken(
                color: ColorsToken.neutral,
              ).altArrowRightLinear,
            ),
            // 구분선
            Gap(SizeToken.m),
            Divider(color: ColorsToken.neutral[200]),
          ],
        ),
      ),
    );
  }
}
