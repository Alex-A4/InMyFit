import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String text) textChanger;

  const SearchBar({Key key, @required this.textChanger}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.search, color: Colors.black54),
          Expanded(
            child: TextField(
              onChanged: widget.textChanger,
              controller: _controller,
              maxLines: 1,
              decoration: InputDecoration(
                border: emptyBorder,
                disabledBorder: emptyBorder,
                enabledBorder: emptyBorder,
                focusedBorder: emptyBorder,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54, fontSize: 22.0, fontFamily: 'Neue'),
            ),
          ),
          GestureDetector(
            child: Icon(Icons.close, color: Colors.black54),
            onTap: () => setState(() => _controller.clear()),
          ),
        ],
      ),
      decoration: ShapeDecoration(
        color: Colors.grey[200],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  final emptyBorder = UnderlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.zero),
  );
}
