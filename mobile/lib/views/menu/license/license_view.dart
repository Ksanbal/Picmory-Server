import 'package:flutter/material.dart';
import 'package:picmory/oss_licenses.dart';
import 'package:solar_icons/solar_icons.dart';
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
        title: const Text("오픈소스 라이센스"),
      ),
      body: ListView.builder(
        itemCount: ossLicenses.length,
        itemBuilder: (context, index) {
          final ossKey = ossLicenses[index];

          return ListTile(
            title: Text(
              ossKey.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(ossKey.description),
            trailing: const Icon(SolarIconsOutline.altArrowRight),
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
