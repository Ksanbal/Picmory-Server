import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picmory/common/families/asset_icon_family.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuViewmodel>(context, listen: true);

    Widget myListTile({
      required Function()? onTap,
      required Widget icon,
      required String title,
      bool showTrailing = true,
    }) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: icon,
        title: Text(
          title,
          style: const TextSmStyle(),
        ),
        trailing: showTrailing
            ? const Icon(
                SolarIconsOutline.altArrowRight,
                color: ColorFamily.disabledGrey500,
              )
            : null,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // 유저 정보
            myListTile(
              onTap: () => vm.routeToUser(context),
              title: "${vm.userName} 님",
              icon: vm.provider == 'google'
                  ? SvgPicture.asset(
                      AssetIconFamily.googleLogo,
                      width: 20,
                      height: 20,
                    )
                  : vm.provider == 'apple'
                      ? const Icon(Icons.apple)
                      : const SizedBox(),
            ),
            // 구분선
            const Divider(color: ColorFamily.disabledGrey300),
            // 메뉴
            // 공지사항
            myListTile(
              onTap: () {},
              title: "공지사항",
              icon: const Icon(SolarIconsOutline.clipboardText),
            ),
            // 이용약관 및 정책
            myListTile(
              onTap: () {},
              title: "이용 약관 및 정책",
              icon: const Icon(SolarIconsOutline.bookBookmarkMinimalistic),
            ),
            // 개인정보처리방침
            myListTile(
              onTap: () {},
              title: "개인정보처리방침",
              icon: const Icon(SolarIconsOutline.eye),
            ),
            // 문의하기
            myListTile(
              onTap: () {},
              title: "문의하기",
              icon: const Icon(SolarIconsOutline.callChat),
            ),
            // 오픈소스 라이센스
            myListTile(
              onTap: () {},
              title: "오픈소스 라이센스",
              icon: const Icon(SolarIconsOutline.infoCircle),
            ),
            // 구분선
            const Divider(color: ColorFamily.disabledGrey300),
            // 앱 버전
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "앱버전 v.${vm.appVersion}",
                style: const TextSmStyle(
                  color: ColorFamily.textGrey700,
                ),
              ),
            ),
            // 로그아웃
            myListTile(
              onTap: () => vm.signout(context),
              title: "로그아웃",
              icon: const Icon(SolarIconsOutline.logout_2),
              showTrailing: false,
            ),
          ],
        ),
      ),
    );
  }
}
