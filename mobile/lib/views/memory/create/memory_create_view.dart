import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:provider/provider.dart';

class MemoryCreateView extends StatelessWidget {
  const MemoryCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemoryCreateViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("메모리 생성"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // 갤러리에서 사진 불러오기 버튼
              TextButton(
                onPressed: vm.getImageFromGallery,
                child: const Text("갤러리에서 사진 불러오기"),
              ),
              // 로드한 사진
              Consumer<MemoryCreateViewmodel>(
                builder: (_, vm, __) {
                  if (vm.selectedImage == null) {
                    return Container();
                  }
                  return Image.file(
                    File(vm.selectedImage!.path),
                  );
                },
              ),
              // 갤러리에서 영상 불러오기 버튼
              TextButton(
                onPressed: vm.getVideoFromGallery,
                child: const Text("갤러리에서 영상 불러오기 버튼"),
              ),
              // 로드한 동영상
              Consumer<MemoryCreateViewmodel>(
                builder: (_, vm, __) {
                  if (vm.selectedVideo == null) {
                    return Container();
                  }
                  return Text(vm.selectedVideo!.path);
                },
              ),
              // qr 스캔 버튼
              TextButton(
                onPressed: null,
                child: Text("qr 스캔 버튼"),
              ),
              // date 입력
              TextButton(
                onPressed: () => vm.showDatePicker(context),
                child: Consumer<MemoryCreateViewmodel>(
                  builder: (_, vm, __) {
                    return Text("입력 날짜 : ${vm.date.toString()}");
                  },
                ),
              ),
              // hashtag 입력
              TextField(
                controller: vm.hashtagController,
                decoration: const InputDecoration(
                  hintText: "해시태그 입력",
                ),
                onSubmitted: vm.hastagOnCSumbitted,
              ),
              // 입력한 해시태그 목록
              Consumer<MemoryCreateViewmodel>(
                builder: (_, vm, __) {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.hashtags.length,
                      itemBuilder: (context, index) {
                        final tag = vm.hashtags[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: InkWell(
                            onTap: () => vm.removeFromHashtags(tag),
                            child: Chip(
                              label: Text(tag),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // 생성 버튼
              TextButton(
                onPressed: () => vm.createMemory(context),
                child: const Text("생성 버튼"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
