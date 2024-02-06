import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/menu/menu_viewmodel.dart';
import 'package:provider/provider.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("메뉴"),
      ),
      body: ListView(
        children: [
          // 로그아웃
          ListTile(
            title: const Text("로그아웃"),
            onTap: () => vm.signout(context),
          ),
        ],
      ),
    );
  }
}
