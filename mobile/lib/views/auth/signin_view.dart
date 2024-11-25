import 'package:animate_do/animate_do.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/messaging_sm_comp.dart';
import 'package:picmory/common/components/common/tooltip_comp.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/families/asset_image_family.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/main.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:provider/provider.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "signin");

    final vm = Provider.of<SigninViewmodel>(context, listen: false);

    final signinButtons = [
      // 애플
      SizedBox(
        width: double.infinity,
        child: PrimaryButtonComp(
          onPressed: () => vm.signinWithApple(context),
          leading: IconsToken(
            color: ColorsToken.white,
          ).apple,
          text: "Apple로 로그인",
          textColor: ColorsToken.white,
          backgroundColor: ColorsToken.black,
        ),
      ),
      Gap(SizeToken.xs),
      // 구글
      SizedBox(
        width: double.infinity,
        child: PrimaryButtonComp(
          onPressed: () => vm.signinWithGoogle(context),
          leading: IconsToken().google,
          text: "Google로 로그인",
          textColor: ColorsToken.black,
          backgroundColor: ColorsToken.white,
          borderColor: ColorsToken.neutral[300],
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          // 상단 텍스트
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 텍스트
                Text(
                  "지금 사진을 기억하세요",
                  style: TypographyToken.titleSm.copyWith(
                    color: ColorsToken.neutral[950],
                  ),
                ),
                Gap(SizeToken.xs),
                // 브랜드 이미지
                ExtendedImage.asset(
                  AssetImageFamily.brand,
                ),
              ],
            ),
          ),
          // 안내, 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeToken.m,
              0,
              SizeToken.m,
              SizeToken.n5xl,
            ),
            child: Consumer<SigninViewmodel>(
              builder: (_, vm, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 안내 문구
                    if (vm.loadProvider)
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        from: 18,
                        child: vm.latestSigninProvider == null
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: MessagingSmComp(
                                  text: "3초안에 회원가입을 해보세요!",
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TooltipComp(
                                  text: "가장 최근에 로그인한 계정입니다",
                                  direction: MessagingSmDirection.down,
                                ),
                              ),
                      ),
                    // 최근 로그인한 로그인 방식 표시
                    ...(vm.latestSigninProvider == null || vm.latestSigninProvider == 'APPLE'
                        ? signinButtons
                        : signinButtons.reversed),
                  ],
                );
              },
            ),
          ),
          Gap(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
