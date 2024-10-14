import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gap/gap.dart';
import 'package:picmory/common/components/common/appbar_comp.dart';
import 'package:picmory/common/components/common/card_comp.dart';
import 'package:picmory/common/components/common/form_comp.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/components/common/messaging_md_comp.dart';
import 'package:picmory/common/components/common/messaging_sm_comp.dart';
import 'package:picmory/common/components/common/primary_button_comp.dart';
import 'package:picmory/common/components/common/scaffold_comp.dart';
import 'package:picmory/common/components/common/select_comp.dart';
import 'package:picmory/common/components/common/slider_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';

class ComponentsView extends StatefulWidget {
  const ComponentsView({super.key});

  @override
  State<ComponentsView> createState() => _ComponentsViewState();
}

class _ComponentsViewState extends State<ComponentsView> {
  @override
  void initState() {
    FlutterNativeSplash.remove();

    super.initState();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldComp(
      context: context,
      extendBody: true,
      appBar: AppBarComp(
        title: "Components",
        actions: [
          AppBarAction(
            icon: IconsToken(
              color: ColorsToken.black,
            ).addFolderLinear,
            reverseIcon: IconsToken(
              color: ColorsToken.white,
            ).addFolderLinear,
            onPressed: () => log("Pressed"),
          ),
          AppBarAction(
            icon: IconsToken(
              color: ColorsToken.black,
            ).hamburgerMenuLinear,
            reverseIcon: IconsToken(
              color: ColorsToken.white,
            ).hamburgerMenuLinear,
            onPressed: () => log("Pressed"),
          ),
        ],
        reverse: false,
      ),
      body: ListView(
        padding: EdgeInsets.only(
            // top: MediaQuery.of(context).padding.top + kToolbarHeight,
            ),
        children: [
          // Control
          Text("Control"),
          SelectComp(
            onSelect: (select) => log(select.toString()),
          ),
          // Slider
          Text("Slider"),
          SizedBox(
            height: 100,
            child: PageView(
              controller: _pageController,
              children: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
                Container(color: Colors.green),
                Container(color: Colors.yellow),
                Container(color: Colors.purple),
              ],
            ),
          ),
          Gap(10),
          SliderComp(
            controller: _pageController,
            count: 5,
          ),
          // Buttons
          Text("Buttons"),
          Row(
            children: [
              PrimaryButtonComp(
                onPressed: () => log("Pressed"),
                text: "button",
                leading: IconsToken(
                  color: ColorsToken.white,
                ).albumBold,
              ),
              Gap(10),
              PrimaryButtonComp(
                onPressed: () => log("Pressed"),
                text: "button",
              ),
            ],
          ),
          Row(
            children: [
              IconButtonComp(
                onPressed: () => log("Pressed"),
                icon: IconsToken(
                  color: ColorsToken.neutral[950]!,
                ).videocameraAddLinear,
              ),
              Gap(10),
              IconButtonComp(
                onPressed: () => log("Pressed"),
                icon: IconsToken(
                  color: ColorsToken.neutral[950]!,
                ).videocameraAddLinear,
                backgroundColor: ColorsToken.neutralAlpha[100]!,
              ),
              Gap(10),
              IconButtonComp(
                onPressed: () => log("Pressed"),
                icon: IconsToken(
                  color: ColorsToken.white,
                ).videocameraAddLinear,
                backgroundColor: Colors.black,
              ),
            ],
          ),
          // Cards
          Text("Cards"),
          CardComp(
            child: SizedBox(
              width: 100,
              height: 100,
            ),
          ),
          // Forms
          Text("Forms"),
          FormComp(
            controller: TextEditingController(),
            maxLength: 20,
            hintText: "plcaeholder",
          ),
          // Messaging
          Text("Messaging"),
          MessagingMdComp(
            text: "'성수역'에 저장됨",
          ),
          Gap(10),
          MessagingSmComp(
            text: "가장 최근에 로그인한 계정입니다",
            direction: MessagingSmDirection.down,
          ),
          Gap(10),
          MessagingSmComp(
            text: "가장 최근에 로그인한 계정입니다",
            direction: MessagingSmDirection.up,
          ),
          Gap(10),
        ],
      ),
    );
  }
}
