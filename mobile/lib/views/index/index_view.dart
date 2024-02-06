import 'package:flutter/material.dart';
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
    return Consumer<IndexViewmodel>(
      builder: (_, vm, __) {
        return Scaffold(
          body: _pages[vm.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              // 홈화면
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "홈",
              ),
              // QR코드
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: "QR코드",
              ),
              // For you
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "For you",
              ),
            ],
            currentIndex: vm.currentIndex,
            onTap: (value) => vm.bottomNavigationHandler(context, value),
          ),
        );
      },
    );
  }
}
