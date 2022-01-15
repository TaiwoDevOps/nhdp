import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhbp/core/providers.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, required this.inActiveIconData});
  String iconData;
  String inActiveIconData;
}

class FABBottomAppBar extends StatefulHookWidget {
  FABBottomAppBar({
    required this.items,
    this.height: 64,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final double height;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: context.read(controllerVM).bottomTapped,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: SizedBox(height: 30),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    var tappedIndex = useProvider(controllerVM.select((_) => _.index));

    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Image.asset(
              tappedIndex == index ? item.iconData : item.inActiveIconData,
              scale: 4,
            ),
          ),
        ),
      ),
    );
  }
}
