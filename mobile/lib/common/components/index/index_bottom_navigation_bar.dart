import 'package:flutter/material.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/common/families/text_styles/caption_sm_style.dart';
import 'package:solar_icons/solar_icons.dart';

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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
      child: SizedBox(
        height: 96,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: _ShadowPainter(),
                child: ClipPath(
                  clipper: _CustomShape(),
                  child: Container(
                    height: 76,
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => onTap(0),
                            highlightColor: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  SolarIconsOutline.home1,
                                  color: currentIndex == 0
                                      ? ColorFamily.primary
                                      : ColorFamily.textGrey700,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "메인",
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
                        const Spacer(),
                        Expanded(
                          child: InkWell(
                            onTap: () => onTap(2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  SolarIconsOutline.notes,
                                  color: currentIndex == 2
                                      ? ColorFamily.primary
                                      : ColorFamily.textGrey700,
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
                      ],
                    ),
                  ),
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
                  SolarIconsBold.galleryAdd,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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

    final point1 = (w - 112) / 2;

    double x = point1;
    double y = 0;

    path.lineTo(point1, 0);
    x = point1;
    y = 0;

    path.conicTo(
      x + 18,
      0,
      x + 18,
      18,
      1,
    );
    x += 18;
    y += 18;

    path.conicTo(
      x,
      y + 30,
      x + 30,
      y + 30,
      1,
    );
    x += 30;
    y += 30;

    path.lineTo(x + 16, y);
    x += 16;
    y += 0;

    path.conicTo(
      x + 30,
      y,
      x + 30,
      18,
      1,
    );
    x += 30;
    y -= 30;

    path.conicTo(
      x,
      0,
      x + 18,
      0,
      1,
    );

    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(0, h);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class _ShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = _CustomShape().getClip(size);
    canvas.drawShadow(path, Colors.black.withOpacity(0.25), 10.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
