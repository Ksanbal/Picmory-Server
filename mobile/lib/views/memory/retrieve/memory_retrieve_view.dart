import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/memory/retrieve/memory_retrieve_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryRetrieveView extends StatelessWidget {
  MemoryRetrieveView({
    super.key,
    required this.memoryId,
  });

  final String memoryId;

  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryRetrieveViewmodel>(context, listen: false);
    vm.getMemory(int.parse(memoryId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            onPressed: () {},
          )
        ],
      ),
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
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Container(
              color: Colors.white,
              height: 50,
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
                      icon: const Icon(Icons.favorite_outline),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.tag_outlined),
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
            ),
          )
        ],
      ),
    );
  }
}
