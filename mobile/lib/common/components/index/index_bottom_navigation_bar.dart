import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';

class IndexBottomNavibationBar extends StatelessWidget {
  const IndexBottomNavibationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onTap(0),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              color:
                                  currentIndex == 0 ? ColorFamily.primary : ColorFamily.textGrey700,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "홈",
                              style: CaptionSmStyle(
                                color: currentIndex == 0
                                    ? ColorFamily.primary
                                    : ColorFamily.textGrey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: _CustomShape(),
                    child: Container(
                      height: 39,
                      width: 69,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => onTap(2),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              color:
                                  currentIndex == 2 ? ColorFamily.primary : ColorFamily.textGrey700,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "추억함",
                              style: CaptionSmStyle(
                                color: currentIndex == 2
                                    ? ColorFamily.primary
                                    : ColorFamily.textGrey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // qr 버튼
          InkWell(
            onTap: () => onTap(1),
            child: Container(
              height: 56,
              width: 56,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorFamily.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x663D34F1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: const Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();

    path.conicTo(0, h / 1.65, w / 3, h / 1.65, 1);
    path.lineTo(w / 3 * 2, h / 1.65);
    path.conicTo(w, h / 1.65, w, 0, 1);
    path.lineTo(w, h);
    path.lineTo(0, h);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
