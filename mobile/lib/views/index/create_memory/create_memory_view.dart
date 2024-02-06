import 'package:flutter/material.dart';

class CreateMemoryView extends StatelessWidget {
  const CreateMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // 카메라 영역
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              margin: const EdgeInsets.all(20),
              color: Colors.grey,
              child: const Center(
                child: Text(
                  "카메라 영역",
                ),
              ),
            ),
          ),
          // 갤러리에서 불러오기 버튼
          TextButton(
            onPressed: () {},
            child: const Text("갤러리에서 불러오기"),
          )
        ],
      ),
    );
  }
}
