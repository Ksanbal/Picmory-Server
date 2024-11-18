import 'package:flutter/material.dart';

class ScaffoldComp extends Scaffold {
  ScaffoldComp({
    super.key,
    required BuildContext context,
    Widget? appBar,
    Widget? body,
    bool extendBody = false,
  }) : super(
          body: Stack(
            children: [
              if (body != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: appBar == null || extendBody
                        ? 0
                        : MediaQuery.of(context).padding.top + kToolbarHeight,
                  ),
                  child: body,
                ),
              if (appBar != null) appBar,
            ],
          ),
        );
}
