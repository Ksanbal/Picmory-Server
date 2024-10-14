import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/effects_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:picmory/common/tokens/layout_token.dart';

class SelectComp extends StatefulWidget {
  const SelectComp({
    super.key,
    required this.onSelect,
    this.select = false,
  });

  @override
  State<SelectComp> createState() => _SelectCompState();

  final bool select;
  final void Function(bool) onSelect;
}

class _SelectCompState extends State<SelectComp> {
  late Widget _animcatedWidget = widget.select ? _SelectedWidget() : _UnSelectedWidget();
  late bool select = widget.select;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        select = !select;
        setState(() {
          _animcatedWidget = select ? _SelectedWidget() : _UnSelectedWidget();
        });
        widget.onSelect(select);
      },
      borderRadius: EffectsToken.pillRadius,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          duration: Duration(milliseconds: 300),
          child: _animcatedWidget,
        ),
      ),
    );
  }
}

class _UnSelectedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeToken.l,
      height: SizeToken.l,
      decoration: BoxDecoration(
        borderRadius: EffectsToken.pillRadius,
        color: ColorsToken.white,
        border: Border.all(
          color: ColorsToken.neutral[400]!,
          width: 1,
        ),
      ),
    );
  }
}

class _SelectedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconsToken().checkCircleBold;
  }
}
