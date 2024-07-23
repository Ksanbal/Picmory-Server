import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';

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
              color: Colors.white,
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
                  color: ColorFamily.disabledGrey400,
                ),
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "서비스 브랜드",
                    style: TextSmStyle(
                      color: ColorFamily.textGrey900,
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
                          style: const TextSmStyle(),
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
