import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';

class SupportBrandsBottomsheet extends StatelessWidget {
  const SupportBrandsBottomsheet(this.brands, {super.key});

  final List<String> brands;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: context.pop,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: ColorsToken.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // 상단 스크롤 안내바
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  width: 70,
                  height: 4,
                  color: ColorsToken.neutral[400],
                ),
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "서비스 브랜드",
                    style: TypographyToken.textSm.copyWith(
                      color: ColorsToken.neutral[950],
                    ),
                  ),
                ),
                // 브랜드 목록
                Expanded(
                  child: ListView.builder(
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          brands[index],
                          style: TypographyToken.textSm.copyWith(
                            color: ColorsToken.neutral[600],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
