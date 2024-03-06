import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:picmory/common/buttons/icon_rounded_button.dart';
import 'package:picmory/common/buttons/icon_rounded_outline_button.dart';
import 'package:picmory/common/families/asset_icon_family.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';
import 'package:picmory/common/families/text_styles/title_lg_style.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SigninViewmodel>(context, listen: false);

    final signinButtons = [
      // 애플
      IconRoundedButton(
        onPressed: () => vm.signinWithApple(context),
        icon: const Icon(
          Icons.apple,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        child: const Text(
          "Apple로 로그인",
          style: TextSmStyle(
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 8),
      // 구글
      IconRoundedOutlineButton(
        onPressed: () => vm.signinWithGoogle(context),
        icon: SvgPicture.asset(
          AssetIconFamily.googleLogo,
          width: 20,
          height: 20,
        ),
        backgroundColor: Colors.white,
        child: const Text(
          "Google로 로그인",
          style: TextSmStyle(
            color: Color(0xFF31333C),
          ),
        ),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadLatestSigninProvider();
    });

    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 이미지
          // Image.network(
          //   "",
          //   fit: BoxFit.cover,
          //   height: double.infinity,
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상단 텍스트
              Padding(
                padding: EdgeInsets.only(top: 66 + MediaQuery.of(context).padding.top),
                child: const Text(
                  "지금 픽모리와\n네컷사진을 기억하세요",
                  textAlign: TextAlign.center,
                  style: TitleLgStyle(
                    color: ColorFamily.textGrey900,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  70 + MediaQuery.of(context).padding.bottom,
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
                                ? Container(
                                    decoration: const BoxDecoration(
                                      color: ColorFamily.primaryLight,
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 18),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          SolarIconsBold.dangerCircle,
                                          color: ColorFamily.primaryDark,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "3초안에 회원가입을 해보세요!",
                                          style: CaptionSmStyle(
                                            color: ColorFamily.primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(16)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                SolarIconsBold.dangerCircle,
                                                color: ColorFamily.primaryDark,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "가장 최근에 로그인한 계정입니다",
                                                style: CaptionSmStyle(
                                                  color: ColorFamily.primaryDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ClipPath(
                                          clipper: _ReverseTriangle(),
                                          child: Container(
                                            color: Colors.white,
                                            width: 12,
                                            height: 8,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        // 최근 로그인한 로그인 방식 표시
                        ...(vm.latestSigninProvider == null || vm.latestSigninProvider == 'apple'
                            ? signinButtons
                            : signinButtons.reversed),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
