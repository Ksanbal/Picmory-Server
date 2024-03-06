import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? ColorFamily.textGrey900 : Colors.white,
          border: isSelected
              ? null
              : Border.all(
                  color: ColorFamily.disabledGrey300,
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: CaptionSmStyle(
                  color: isSelected ? Colors.white : ColorFamily.textGrey600,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.close,
                size: 16,
                color: Colors.white.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
