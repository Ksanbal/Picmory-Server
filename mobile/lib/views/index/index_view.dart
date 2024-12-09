import 'package:flutter/material.dart';
import 'package:picmory/common/components/index/index_bottom_navigation_bar.dart';
import 'package:picmory/viewmodels/index/index_viewmodel.dart';
import 'package:picmory/views/index/for_you/for_you_view.dart';
import 'package:picmory/views/index/home/home_view.dart';
import 'package:provider/provider.dart';

class IndexView extends StatelessWidget {
  IndexView({super.key});

  final List<Widget> _pages = [
    // 홈
    const HomeView(),
    // QR코드
    Container(),
    // For you
    const ForYouView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexViewmodel>(
        builder: (_, vm, __) {
          return Stack(
            children: [
              _pages[vm.currentIndex],
              Align(
                alignment: Alignment.bottomCenter,
                child: IndexBottomNavibationBar(
                  currentIndex: vm.currentIndex,
                  onTap: (value) => vm.bottomNavigationHandler(context, value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
