import 'package:flutter/material.dart';

class MyFitAppBarItem {
  final String icon;
  final String title;

  MyFitAppBarItem({this.icon, this.title});
}

class MyFitAppBar extends StatefulWidget {
  final double height;
  final double iconSize;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color backgroundColor;
  final ValueChanged<int> onTabSelected;
  final List<MyFitAppBarItem> items;

  MyFitAppBar({
    Key key,
    this.height,
    this.iconSize,
    this.activeIconColor,
    this.inactiveIconColor,
    this.onTabSelected,
    this.items,
    this.backgroundColor,
  })  : assert(items.length > 1),
        super(key: key);

  @override
  _MyFitAppBarState createState() => _MyFitAppBarState();
}

class _MyFitAppBarState extends State<MyFitAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(
        widget.items.length,
        (int index) => _buildTabItem(
            item: widget.items[index], index: index, onPressed: _updateIndex));

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem(
      {MyFitAppBarItem item, int index, ValueChanged<int> onPressed}) {
    Color color = _selectedIndex == index
        ? widget.activeIconColor
        : widget.inactiveIconColor;

    return SizedBox(
      height: widget.height,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          onTap: () => onPressed(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ImageIcon(
                AssetImage(item.icon),
                color: color,
                size: widget.iconSize,
              ),
              Text(
                item.title,
                style: TextStyle(color: color, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
