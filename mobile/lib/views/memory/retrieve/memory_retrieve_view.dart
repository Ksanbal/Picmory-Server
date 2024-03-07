import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryRetrieveView extends StatelessWidget {
  const MemoryRetrieveView({
    super.key,
    required this.memoryId,
  });

  final String memoryId;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryRetrieveViewmodel>(context, listen: false);
    vm.getMemory(int.parse(memoryId));

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MemoryRetrieveViewmodel>(
              builder: (_, vm, __) {
                final memory = vm.memory;

                if (memory == null) return Container();

                return ExtendedImage.network(
                  memory.photoUri,
                  mode: ExtendedImageMode.gesture,
                );
              },
            ),
          ),
          // 하단 선택바
          Container(
            height: 50 + MediaQuery.of(context).padding.bottom,
            color: Colors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Consumer<MemoryRetrieveViewmodel>(
                      builder: (_, vm, __) {
                        if (vm.memory == null) return Container();

                        return Icon(
                          vm.memory!.isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: vm.memory!.isLiked ? ColorFamily.error : null,
                        );
                      },
                    ),
                    onPressed: vm.likeMemory,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.folder_open_outlined),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
