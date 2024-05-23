import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuViewmodel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // 구분선
            const Divider(color: ColorFamily.disabledGrey300),
            // 탈퇴
            ListTile(
              onTap: () => vm.withdraw(context),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "회원탈퇴",
                style: TextSmStyle(),
              ),
              trailing: const Icon(
                SolarIconsOutline.altArrowRight,
                color: ColorFamily.disabledGrey500,
              ),
            ),
            // 구분선
            const Divider(color: ColorFamily.disabledGrey300),
          ],
        ),
      ),
    );
  }
}
