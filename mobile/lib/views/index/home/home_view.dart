import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picmory/viewmodels/index/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewmodel>(context, listen: false);

    vm.clearMemories();
    vm.loadMemories();

    return Consumer<HomeViewmodel>(builder: (_, vm, __) {
      return MasonryGridView.count(
        crossAxisCount: 2,
        itemCount: vm.memories.length,
        itemBuilder: (context, index) {
          final memory = vm.memories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사진
                Card(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      memory.photoUri,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(Icons.more_horiz),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
