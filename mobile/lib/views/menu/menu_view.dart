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
          style: TypographyToken.textSm.copyWith(
            color: ColorsToken.neutral[950],
          ),
        ),
        trailing: showTrailing
            ? IconsToken(
                color: ColorsToken.neutral,
              ).altArrowRightLinear
            : null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsToken.neutral[50],
        leading: IconButtonComp(
          onPressed: context.pop,
          icon: IconsToken().altArrowLeftLinear,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 유저 정보
          myListTile(
            onTap: () => vm.routeToUser(context),
            title: "${vm.userName} 님",
            icon: vm.provider == 'GOOGLE'
                ? IconsToken().google
                : vm.provider == 'APPLE'
                    ? IconsToken(color: ColorsToken.black).apple
                    : const SizedBox(),
          ),
          // 구분선
          Gap(SizeToken.m),
          Divider(color: ColorsToken.neutral[200]),
          Gap(SizeToken.m),
          // 메뉴
          // 공지사항
          myListTile(
            onTap: () => vm.showNotice(context),
            title: "공지사항",
            icon: IconsToken().clipboardTextLinear,
          ),
          // 이용약관 및 정책
          myListTile(
            onTap: () => vm.showTermsAndPolicy(context),
            title: "이용 약관 및 정책",
            icon: IconsToken().bookBookmarkMinimalisticLinear,
          ),
          // 개인정보처리방침
          myListTile(
            onTap: () => vm.showPrivacyPolicy(context),
            title: "개인정보처리방침",
            icon: IconsToken().eyeLinear,
          ),
          // 문의하기
          myListTile(
            onTap: vm.contactUs,
            title: "문의하기",
            icon: IconsToken().callChatLinear,
          ),
          // 오픈소스 라이센스
          myListTile(
            onTap: () => vm.routeToLicense(context),
            title: "오픈소스 라이센스",
            icon: IconsToken().infoCircleLinear,
          ),
          // 구분선
          Gap(SizeToken.m),
          Divider(color: ColorsToken.neutral[200]),
          Gap(SizeToken.m),
          // 앱 버전
          InkWell(
            onTap: () => vm.activeDeveloperMode(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "앱버전 v.${vm.appVersion}",
                style: TypographyToken.textSm.copyWith(
                  color: ColorsToken.neutral[700],
                ),
              ),
            ),
          ),
          // 로그아웃
          myListTile(
            onTap: () => vm.signout(context),
            title: "로그아웃",
            icon: IconsToken().logout2Outline,
            showTrailing: false,
          ),
        ],
      ),
    );
  }
}
