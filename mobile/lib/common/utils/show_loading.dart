import 'package:flutter/material.dart';
import 'package:picmory/common/components/loading_widget.dart';

OverlayState? overlayState;
OverlayEntry? overlayEntry;

showLoading(BuildContext context) {
  overlayState = Overlay.of(context);
  overlayEntry = OverlayEntry(
    builder: (context) => const LoadingWidget(),
  );

  overlayState!.insert(overlayEntry!);
}

removeLoading() {
  if (overlayEntry != null) {
    overlayEntry!.remove();
    overlayEntry = null;
  }
}
