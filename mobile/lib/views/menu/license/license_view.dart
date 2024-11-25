import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/typography_token.dart';
import 'package:picmory/oss_licenses.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LicenseView extends StatelessWidget {
  const LicenseView({super.key});

  static Future<List<String>> loadLicenses() async {
    final ossKeys = List<String>.from(ossLicenses);
    return ossKeys..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsToken.neutral[50],
        title: Text(
          "오픈소스 라이센스",
          style: TypographyToken.textMd,
        ),
        leading: IconButtonComp(
          onPressed: context.pop,
          icon: IconsToken().altArrowLeftLinear,
        ),
      ),
      body: ListView.builder(
        itemCount: ossLicenses.length,
        itemBuilder: (context, index) {
          final ossKey = ossLicenses[index];

          return ListTile(
            title: Text(
              ossKey.name,
              style: TypographyToken.textLg,
            ),
            subtitle: Text(
              ossKey.description,
              style: TypographyToken.captionSm,
            ),
            trailing: IconsToken(
              color: ColorsToken.neutral,
            ).altArrowRightLinear,
            onTap: () {
              if (ossKey.repository != null) {
                launchUrlString(ossKey.repository!);
              }
            },
          );
        },
      ),
    );
  }
}
