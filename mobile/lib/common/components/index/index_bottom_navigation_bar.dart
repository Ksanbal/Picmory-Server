import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';

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
        height: 84,
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
                    height: 64,
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: ColorsToken.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 0, 12),
                            child: InkWell(
                              onTap: () => onTap(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconsToken(
                                    size: IconTokenSize.large,
                                    color:
                                        currentIndex == 0 ? ColorsToken.primary : ColorsToken.black,
                                  ).homeOutline
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 20, 12),
                            child: InkWell(
                              onTap: () => onTap(2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconsToken(
                                    size: IconTokenSize.large,
                                    color:
                                        currentIndex == 2 ? ColorsToken.primary : ColorsToken.black,
                                  ).heartLinear
                                ],
                              ),
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
                height: SizeToken.n5xl,
                width: SizeToken.n5xl,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorsToken.primary,
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
                child: Center(
                  child: IconsToken(
                    size: IconTokenSize.large,
                    color: ColorsToken.white,
                  ).qrCodeOutline,
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
