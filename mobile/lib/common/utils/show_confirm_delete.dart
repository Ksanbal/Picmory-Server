import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/buttons/rounded_button.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/text_sm_style.dart';

Future<bool?> showConfirmDelete(BuildContext context) async {
  return await showDialog(
    context: context,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  onPressed: () => context.pop(true),
                  backgroundColor: Colors.white,
                  child: const Text(
                    "삭제",
                    style: TextSmStyle(
                      color: ColorFamily.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  onPressed: () => context.pop(false),
                  backgroundColor: Colors.white,
                  child: const Text(
                    "취소",
                    style: TextSmStyle(
                      color: ColorFamily.textGrey700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
