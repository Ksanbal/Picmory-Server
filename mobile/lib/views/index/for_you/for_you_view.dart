import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/index/for_you/for_you_viewmodel.dart';
import 'package:provider/provider.dart';

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForYouViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => vm.routeToMenu(context),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: const Center(
        child: Text("For you"),
      ),
    );
  }
}
